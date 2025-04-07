extends Node2D
# https://dev.twitch.tv/docs/eventsub/handling-websocket-events/#welcome-message

var DEBUG:bool = true

@onready var myController:Node = get_parent().get_parent()
@onready var myUser:Node = get_parent().get_node("User")

@onready var mySocket = WebSocketPeer.new()
var websocket_url = "wss://eventsub.wss.twitch.tv/ws"

@onready var myHTTPRequest:HTTPRequest = $HTTPRequest
@onready var sub_headers:Array = ["Authorization: Bearer " + myUser.bot_pubsub_token, "Client-Id: " + myUser.client_id, "Content-Type: application/json"]
var sub_url:String = "https://api.twitch.tv/helix/eventsub/subscriptions"
var transport:Dictionary = { "method": "websocket", "session_id": "null" }

var sessionID:String # session ID used for subscribing to events

func _ready():
	myHTTPRequest.request_completed.connect(_on_request_completed)
	
	# Initiate connection
	var err = mySocket.connect_to_url(websocket_url)
	if err != OK:
		if DEBUG: util.debugPrint("EU", true, "Unable to connect")
		set_process(false)

func _process(_delta):
	# poll for data
	mySocket.poll()
	var state = mySocket.get_ready_state()

	# connected and ready to send/receive data.
	if state == WebSocketPeer.STATE_OPEN:
		while mySocket.get_available_packet_count():
			handlePacket(mySocket.get_packet())
				
	# socket is closing.
	elif state == WebSocketPeer.STATE_CLOSING:
		# keep polling for a clean close.
		pass

	# connection has fully closed.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be -1 if the disconnection was not properly notified by the remote peer.
		var code = mySocket.get_close_code()
		if DEBUG: util.debugPrint("EU", true, "WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		
		# now safe to stop polling.
		set_process(false)

func handlePacket(packet:PackedByteArray):
	if packet == null: return
	
	var data:Dictionary = JSON.parse_string(packet.get_string_from_utf8())
	var metadata:Dictionary = data["metadata"]
	var msgType:String = metadata["message_type"].to_upper()
	
	if DEBUG: util.debugPrint("ED", true, "Received packet; " +  str(data))
	
	if msgType == "SESSION_WELCOME":
		sessionID = data["payload"]["session"]["id"]
		transport["session_id"] = sessionID
		if DEBUG:
			util.debugPrint("B", true, "Received session welcome message.")
			util.debugPrint("B", true, "   ...Session ID set to " + str(sessionID))
		
		var dataPackage:Dictionary = 	{ "type": "channel.channel_points_custom_reward_redemption.add",
										  "version": "1",
										  "condition": { "broadcaster_user_id": str(myUser.channel_id) },
										  "transport": transport
										}
		
		util.debugPrint("EU", true, "Sending subscription request.")
		var err = myHTTPRequest.request(sub_url, sub_headers , HTTPClient.METHOD_POST, str(dataPackage))
		if DEBUG and err: util.debugPrint("B", true, "   ...Error " + str(err))
		
	elif msgType == "NOTIFICATION": 
		print(" !!!!!!!!!! ", str(data))
		
		var notifType:String = metadata["subscription_type"]
		var event:Dictionary = data["payload"]["event"]
		
		if DEBUG:
			util.debugPrint("ED", true, "Notification; " + str(notifType))
			util.debugPrint("ED", true, " ..." + str(event))
		
		var redeem:Dictionary = {"Title": event["reward"]["title"], "Login": event["user_login"], "Input": event["user_input"]}
		myController.handleRedeem(redeem)
		
	else:
		if msgType != "SESSION_KEEPALIVE":
			if DEBUG: util.debugPrint("ED", true, "Unknown message " + str(msgType))
		
func _on_request_completed(result, response_code, headers, body):
	if DEBUG: util.debugPrint("ED", true, "[" + str(result) + "; " + str(response_code) + "] .. " + body.get_string_from_utf8() ) 

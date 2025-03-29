extends Node2D


@onready var myPingTimer: Timer = $PingTimer
@onready var myUser = get_parent().get_node("User")
@onready var myController = get_parent().get_parent()

# Our WebSocketClient instance
var _pubsub_client = WebSocketPeer.new()
var pubsub_url = "wss://pubsub-edge.twitch.tv" 

# Set to true to recieve debug console output
@export var DEBUG: bool = true

var currentState = null
var previousState = null

var pubRewardTitle:String = ""
var pubUserLogin:String = ""
var pubUserInput:String = ""

func _startup():
	#initiate PubSub connection
	if DEBUG: util.debugPrint("B", true, "PubSub Controller node identified as " + myController.name) 
	_pubsub_client.connect_to_url(pubsub_url)
	
	
func _process(_delta):
	#Data transfer and signals emission will only happen when calling this function.
	_pubsub_client.poll()
	#gd4 abandoned the signals that used to exist for websockets in favor if a state machine
	previousState = currentState
	currentState = _pubsub_client.get_ready_state()
	
	if currentState == WebSocketPeer.STATE_OPEN:
		if previousState != WebSocketPeer.STATE_OPEN:
			if DEBUG: util.debugPrint("B", true, "PubSub Connection STATE_OPEN")
			#mySetupTimer.start()
			var payload = '{"type":"LISTEN", "data":{"topics": ["channel-points-channel-v1.%s"], "auth_token":"%s"}}' % [str(myUser.channel_id), str(myUser.bot_pubsub_token)]
			send_data(payload, false) #keep false flag to keep this from outputing your oauth token to the console
	
		#retrieve and decode available packets, pass to data parsing function
		while _pubsub_client.get_available_packet_count():
			# returns the following dictionary based on a channel point redemption and sends it to the controller
			# {"Title":pubRewardTitle, "Login":pubUserLogin, "Input":pubUserInput}
			var redeem:Dictionary = pubsub_on_data(_pubsub_client.get_packet().get_string_from_utf8())
			if redeem.has("Title"): myController.handleRedeem(redeem)
			
	elif currentState == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
		
	elif currentState == WebSocketPeer.STATE_CLOSED:
		if previousState != WebSocketPeer.STATE_CLOSED:
			var code = _pubsub_client.get_close_code()
			var reason = _pubsub_client.get_close_reason()
			if DEBUG: util.debugPrint("B", true,  "WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
			set_process(false) # Stop processing.
			


# returns the following dictionary based on a channel point redemption
# {"Title":pubRewardTitle, "Login":pubUserLogin, "Input":pubUserInput}
func pubsub_on_data(packet:String):
	
	#if debug, trim and print packet
	if DEBUG:
		var smallPacket = packet
		if len(smallPacket) > 100: smallPacket = smallPacket.left(100) + "..."
		print(util.prefix("PD") + smallPacket.strip_escapes().strip_edges())

	
	var repackaged:Dictionary = JSON.parse_string(packet)
	
	if repackaged.has("data"):
		repackaged = repackaged["data"]
		if repackaged.has("message"):
			repackaged = JSON.parse_string(repackaged["message"])
			if repackaged.has("data"):
				repackaged = repackaged["data"]
				if repackaged.has("redemption"):
					repackaged = repackaged["redemption"]
					var pubUser: Dictionary = {}
					var pubReward: Dictionary = {}
					
					if repackaged.has("user"): pubUser = repackaged["user"]
					if repackaged.has("reward"): pubReward = repackaged["reward"]
					
					if not pubUser == {} and not pubReward == {}:
						# WE GOT EM
						pubRewardTitle = pubReward["title"]
						pubUserLogin = pubUser["login"]
						if repackaged.has("user_input"): pubUserInput = str(repackaged["user_input"])
						
						repackaged.clear()
						repackaged = {"Title":pubRewardTitle, "Login":pubUserLogin, "Input":pubUserInput}
						
#					else: if DEBUG:print(util.prefix("B"), "repackaged>data>message>data>redemption")
#				else: if DEBUG: print(util.prefix("B"), "repackaged>data>message>data")
#			else: if DEBUG: print(util.prefix("B"), "repackaged>data>message")
#		else: if DEBUG: print(util.prefix("B"), "repackaged>data")
#	else: if DEBUG: print(util.prefix("B"), "repackaged")

	return(repackaged)
	
#func send_data(client: WebSocketClient, string: String):
func send_data(string: String, Print: bool=true):
	#send the provided string to the server
	if DEBUG and Print: print(util.prefix("PU"), string)
	#client.get_peer(1).put_packet(string.to_utf8_buffer())
	_pubsub_client.send_text(string)


func _on_PingTimer_timeout(): 
	send_data('{"type": "PING"}')
	# set the ping timer to be 1-3 min
	# twitch API recommends introducing this randomness to the client ping time
	myPingTimer.wait_time = 60 + int(randf_range(0, 120))

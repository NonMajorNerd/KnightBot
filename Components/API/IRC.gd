extends Node2D
class_name IRC

# Set to true to recieve optional console output
@export var DEBUG: bool = true

@onready var myController = get_parent().get_parent()

@onready var mySetup: Timer = $Setup
@onready var myUser = get_parent().get_node("User")

@onready var chatters = [] #a list of estimated users in chat, managed by JOIN/PART messages

var _irc_client = WebSocketPeer.new()
var irc_url = "ws://irc-ws.chat.twitch.tv:80"

var irc_pass = 0

var currentState = null
var previousState = null
	
func _startup():
	#initiate irc connection
	if DEBUG: util.debugPrint("B", true, "IRC Controller node identified as " + myController.name)
	_irc_client.connect_to_url(irc_url)
		
func _process(_delta):
	#Data transfer and signals emission will only happen when calling this function.
	_irc_client.poll()
	
	#gd4 abandoned the signals that used to exist for websockets in favor if a state machine
	previousState = currentState
	currentState = _irc_client.get_ready_state()
	
	if currentState == WebSocketPeer.STATE_OPEN:
		if previousState != WebSocketPeer.STATE_OPEN:
			if DEBUG: util.debugPrint("B", true, "IRC Connection STATE_OPEN")
			mySetup.start()
			
		#retrieve and decode available packets, pass to data parsing function	
		while _irc_client.get_available_packet_count():
			irc_on_data(_irc_client.get_packet().get_string_from_utf8())
			
	elif currentState == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
		
	elif currentState == WebSocketPeer.STATE_CLOSED:
		var code = _irc_client.get_close_code()
		var reason = _irc_client.get_close_reason()
		util.debugPrint("ID", true, "WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.

func irc_on_data(packet: String):
	
	#if debug, trim and print packet
	if DEBUG:
		var smallpacket = packet
		if smallpacket.length() > 100: smallpacket = smallpacket.left(100) + "..."
		util.debugPrint("B", true, str(smallpacket).strip_escapes())

	var splitPacket = packet.split("\r\n")
	for line in splitPacket:
		if line.strip_edges().length() == 0: break
		var parsedMessage = parseMessage(line) #built based on https://dev.twitch.tv/docs/irc/example-parser/
		
		if DEBUG and parsedMessage["source"] != null: util.debugPrint("B", true, str(parsedMessage))

		if parsedMessage["command"] != null:
			match str(parsedMessage["command"]["command"]):
				
				"PRIVMSG":
					
					# very jank way of ensuring that everyone in chat has be "join" processed
					myController.handleJoin(str(parsedMessage["source"]["nick"]))
					
					if parsedMessage["command"].has("botCommand"):
						var params = ""
						if parsedMessage["command"].has("botCommandParams"): params = str(parsedMessage["command"]["botCommandParams"])
						myController.handleCommand(parsedMessage["source"]["nick"], parsedMessage["command"]["botCommand"], params)
						
					else:
						myController.handleChat(parsedMessage["source"]["nick"], parsedMessage["parameters"])

				"PING":
					send_data("PONG :tmi.twitch.tv")
					
				"JOIN":
					myController.handleJoin(str(parsedMessage["source"]["nick"]))
					
				"PART":
					myController.handlePart(str(parsedMessage["source"]["nick"]))
					
				_:
					pass
					#if DEBUG: print(util.prefix("B"), "Unhandled parsed message; ", str(parsedMessage))
					
#built based on https://dev.twitch.tv/docs/irc/example-parser/
func parseMessage(message:String) -> Dictionary:
	#this and related functions built based on https://dev.twitch.tv/docs/irc/example-parser/
	#if DEBUG: util.debugPrint("B", true, "Parsing message;   " + str(message))
		
	var results:Dictionary = { "tags":null, "source":null, "command":null, "parameters":null}
	var msgArray:Array = message.split("")
	
	var index:int = 0
	var rawTags = null
	var rawSource = null
	var rawCommand = null
	var rawParameters = null
	
	#if character 0 is an @, the first section is tags data.
	if msgArray[index] == "@":
		var end:int = message.find(" ", index)
		rawTags = message.substr(1,end-1).strip_edges()
		#if DEBUG: print(util.prefix("B"), "Found tags data from index ", str(index), " to ", str(end), "; ", str(rawTags))
		index = end + 1

	#if we had tags, index will now be after tags.. otherwise index is still at 0 and this is the first character (no tags for this message)
	if msgArray[index] == ":":
		var end:int = message.find(" ", index)
		rawSource = message.substr(index+1, end-index).strip_edges()
		#if DEBUG: print(util.prefix("B"), "Found source data from index ", str(index+1), " to ", str(end), "; ", str(rawSource))
		index = end + 1
		
	#get the command component
	var end:int = message.find(":", index)
	#if there are no parameters, point to the end of the message
	if end == -1: end = message.length()
	
	rawCommand = message.substr(index, end-index).strip_edges()
	
	#if DEBUG: print(util.prefix("B"), "Found command data from index ", str(index), " to ", str(end), "; ", str(rawCommand))
	
	#get the parameters if we have them
	if end != message.length():
		index = end+1
		rawParameters = message.substr(index)
		#if DEBUG: print(util.prefix("B"), "Found parameter data from index ", str(index), " to ", str(end), "; ", str(rawParameters))
	
	results["command"] = parseCommand(rawCommand)
	
	if results["command"] != null:
		if rawTags != null: 
			results["tags"] = parseTags(rawTags) # EMPTY DICT! Not currently used
	
		results["source"] = parseSource(rawSource)
		results["parameters"] = rawParameters
		
		if rawParameters != null and rawParameters.left(1) == "!":
			# The user entered a bot command in the chat window.            
			results["command"] = parseParameters(rawParameters,results["command"])
			
	return results

func parseCommand(rawCommand):
	#if DEBUG: print(util.prefix("B"), "Parsing command ", str(rawCommand))
		
	var result = null
	var commandParts = rawCommand.split(" ")
			
	match commandParts[0]:
		"JOIN":
			result = { 	"command": commandParts[0], "channel": commandParts[1] }
		"PART":
			result = { 	"command": commandParts[0], "channel": commandParts[1] }
		"NOTICE":
			pass
		"CLEARCHAT":
			pass
		"HOSTTARGET":
			pass
		"PRIVMSG":
			result = { 	"command": commandParts[0], "channel": commandParts[1] }
		'PING':
			result = { "command": commandParts[0] }
		'CAP':
			result = { "command": commandParts[0] }
			if commandParts[2] and commandParts[2] == "ACK":    # The parameters part of the messages contains the enabled capabilities.
				result["isCapRequestEnabled"] = commandParts[2]
				
		'GLOBALUSERSTATE':  # Included only if you request the /commands capability.But it has no meaning without also including the /tags capability.
			result = {"command": commandParts[0]}             
		'USERSTATE':   # Included only if you request the /commands capability.
			pass
		'ROOMSTATE':   # But it has no meaning without also including the /tags capabilities.
			result = { "command": commandParts[0], "channel": commandParts[1] }
		'RECONNECT':
			util.debugPrint("ID", true, 'The Twitch IRC server is about to terminate the connection for maintenance.')  
			result = {"command": commandParts[0]}
		'421':
			pass
		'001':  # Logged in (successfully authenticated). 
			result = { "command": commandParts[0], "channel": commandParts[1] }
		'002':
			pass
		'003':
			pass
		'004':
			pass
		'353':  # Tells you who else is in the chat room youre joining. Might be useful to scan this to restore activeusers when the bot is restarted
			# for users in command
			pass
		'366':
			pass
		'372':
			pass
		'375':
			pass
		'376':
			pass

				
	return result			

func parseTags(_rawTags):
	#not currently doing anything with this data. returns an empty dict
	#could parse tags w something like this
	
#	var tagsData = {}
#	var splitTags = rawTags.split(";")
#
#	for tag in splitTags:
#		var tagData = tag.split("=") #tags are KVP strings, split on the =
#		var tagValue = null
#		if tagData[1] != "": tagValue = tagData[1] #assign value if relevant
#
#		match tagData[0]: # match pattern on tag name
#			"badges":
#				pass
#			"badge-info":
#				pass
#			"emotes":
#				pass
			
	return {}
		
	
func parseSource(rawSource):
	#if DEBUG: util.debugPrint("B", true, "Parsing Source; " + str(rawSource))  
	if rawSource == null: return null
	var sourceParts = rawSource.split("!")
	
	var nick = null
	var host = null
	
	if sourceParts.size() == 2:
		nick = str(sourceParts[0]).strip_edges()
		host = str(sourceParts[1]).strip_edges()
	else:
		host = str(sourceParts[0]).strip_edges()
		
	return {"nick":nick, "host":host}


func parseParameters(rawParameters:String, command:Dictionary):
	var index:int = 0
	var commandParts:String = rawParameters.substr(index+1).strip_edges()
	var paramIndex:int = commandParts.find(" ")
	
	if paramIndex == -1: #no params
		command["botCommand"] = commandParts.substr(0).strip_edges()
	else:
		command["botCommand"] = commandParts.substr(0,paramIndex).strip_edges()
		command["botCommandParams"] = commandParts.substr(paramIndex).strip_edges()
	
	return command


func send_data(string: String, Print: bool=true):
	#send the provided string to the server. Optional boolean to turn off printing for sensative data sends
	if DEBUG and Print: util.debugPrint("IU", true, string)  
	_irc_client.send_text(string)


func _on_Setup_timeout():
	#This timer function iterates through a number of IRC send/recieve steps
	#each one second apart from the last to give the server time to respond
	irc_pass += 1
	
	if irc_pass == 1:
		#https://dev.twitch.tv/docs/irc/capabilities/
		send_data("CAP REQ :twitch.tv/commands twitch.tv/tags twitch.tv/membership")
	elif irc_pass == 2:
		send_data("PASS oauth:" + myUser.bot_irc_token, false)
	elif irc_pass == 3:
		send_data("NICK " + myUser.bot_name)
	elif irc_pass == 4:
		send_data("JOIN #" + myUser.channel_name)
	elif irc_pass ==5:
		send_data("PRIVMSG #nonmajornerd :She blinded me with science!")
	else:
		mySetup.stop()

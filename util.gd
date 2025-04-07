extends Node

# A set of tools and functions to be used across other scripts.
# Housed here and loaded via project settings so that it's always in scope.


func prefix(type:String="B", timestamp:bool=true):
	var result:String = ""
	if timestamp: result += str(Time.get_time_string_from_system())
	
	if type == "B": result += 		"  [BOT] "
	elif type == "EU": result += 	" [EVT▲]"
	elif type == "ED": result += 	" [EVT▼]"
	elif type == "HU": result += 	" [HLX▲]"
	elif type == "HD": result += 	" [HLX▼]"
	elif type == "IU": result += 	" [IRC▲] "
	elif type == "ID": result += 	" [IRC▼] "
	elif type == "PU": result += 	" [PUB▲] "
	elif type == "PD": result += 	" [PUB▼] "
	
	return result

func debugPrint(type:String="B", timestamp:bool=true, message:String=""):
	var msg:String = censorMessage(message)
	print(prefix(type, timestamp), " ", msg)

func censorMessage(msg:String=""):
	var myUser = get_tree().current_scene.find_child("User")
	var censorString = "██████████"

	msg = msg.replace(myUser.client_id, censorString)
	msg = msg.replace(myUser.channel_id, censorString)
	msg = msg.replace(myUser.bot_id,censorString)
	msg = msg.replace(myUser.bot_pubsub_token, censorString)
	msg = msg.replace(myUser.bot_irc_token, censorString)
	
	return msg

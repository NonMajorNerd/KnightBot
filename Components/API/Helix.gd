extends Node2D
class_name Helix

# Set to true to recieve optional console output
@export var DEBUG:bool = true

@onready var myController:Node = get_parent().get_parent()
@onready var myHTTPRequest:HTTPRequest = $HTTPRequest
@onready var myAdTimer:Timer = $Timer
@onready var myUser:Node = get_parent().get_node("User")

@onready var ad_headers:Array = ["Authorization: Bearer " + myUser.bot_pubsub_token, "Client-Id: " + myUser.client_id]
@onready var ad_url:String = "https://api.twitch.tv/helix/channels/ads?broadcaster_id=" + myUser.channel_id
var taverned:bool = false # has the tavern kicked off yet
var adTavernBuffer:int = 600 # how many seconds before the ad the tavern will try to play
var adBufferTime:int = 30 # how many seconds before the ad that the normal message should be displayed
var adLength:int = 180 # how long the ad is, defaults to 3 min
var adMessage:String = "An ad is starting in " + str(adBufferTime) + " seconds to prevent preroll ads for incoming vieiwers." # Stick around for a public event after the ad break!"
var adTimerPhase:int = 0 #which phase of action the timer is on... 0 = needs to request info, 1 = needs to send message, 2 = needs to start event

@onready var announcement_headers:Array = ["Authorization: Bearer " + myUser.bot_irc_token, "Client-Id: " + myUser.client_id, "Content-Type: application/json"]
@onready var announcement_url:String = "https://api.twitch.tv/helix/chat/announcements?broadcaster_id=" + myUser.channel_id + "&moderator_id=" +  myUser.bot_id

func _ready():
	myHTTPRequest.request_completed.connect(_on_request_completed)
	myAdTimer.start(adBufferTime)

func _on_timer_timeout():
	if DEBUG: util.debugPrint("B", true, "Ad timer engaging phase " + str(adTimerPhase))
	
	if adTimerPhase == 0:
		if DEBUG: util.debugPrint("HU", true, "Timed Ad Request")
		myHTTPRequest.request(ad_url, ad_headers, HTTPClient.METHOD_GET)
		
	elif adTimerPhase == 1:
		#myController.myIRCController.send_data("PRIVMSG #nonmajornerd : " + adMessage)
		announcementRequest(adMessage)
		adTimerPhase = 2
		myAdTimer.start(adLength + 15)
		
		
	elif adTimerPhase == 2:
		if DEBUG: print(util.prefix("H"), " Something something public event")
		# go back to phase 0 to get ad schedule data
		adTimerPhase = 0
		myAdTimer.start(adBufferTime)
	
	# TODO:: Announce tavern prior to running it
	elif adTimerPhase == 10:
		# host tavern. this will set taverened to true
		myController.hostTavern()
		# go back to phase 0 to get ad schedule data
		adTimerPhase = 0
		myAdTimer.start(adBufferTime)
	
	else:
		print(util.prefix("H"), " !! ERROR !! Unexpected ad timer phase ", str(adTimerPhase), "; Resetting to phase 0, 5 second wait.")
		adTimerPhase = 0
		myAdTimer.start(5)
		
func announcementRequest(msg:String = "", color:String=""):
	if DEBUG: print(util.prefix("HU"), " Announcement Request")
	var dataPackage:Dictionary = {"message" : msg } #str('"' + msg + '"')} #, ", color" : str('"' + color + '"')}
	myHTTPRequest.request(announcement_url, announcement_headers , HTTPClient.METHOD_POST, str(dataPackage))
		
func _on_request_completed(result, response_code, headers, body):
	
	if response_code in [204, 400, 404]:
		if DEBUG: print(util.prefix("HD"), "   ...HTTP Response Code " + str(response_code))
		
	else:
		var json:Dictionary = JSON.parse_string(body.get_string_from_utf8())
		if DEBUG: print(util.prefix("H"), "   ...HTTP Response; " + str(json))
		
		if json.has("error"):
			print(util.prefix("HD"), "   ...!! ERROR !! ", json["error"], "; ", json["message"])
			
		elif not json.has("data"):
			print(util.prefix("HD"), "   ...Unexpected non-error response. .. Response; ", str(json))
			
		else:
			var currentTime:float = Time.get_unix_time_from_system()
			var nextAdTime:float = float(json["data"][0]["next_ad_at"])
			var adTimeDiff:int = int(nextAdTime - currentTime)
			if DEBUG: print(util.prefix("H"), " Ad time diff sec; " + str(adTimeDiff))
			
			# if we get weird data back
			if adTimeDiff < 0:
				# try another ad request
				adTimerPhase = 0
				myAdTimer.start(adBufferTime)
			
			# if we think we have good data
			else:
				# if we haven't done a tavern yet
				if not taverned:
					
					# set up for a tavern
					var tavernDelta:int = int(adTimeDiff - adTavernBuffer)
					if  tavernDelta > 30:
						# send the timer to kick of a tavern at tavernDelta and phase 10 for tavern
						adTimerPhase = 10
						adLength = int(json["data"][0]["duration"])
						myAdTimer.start(tavernDelta)
						
				# else set up for a normal ad
				else:
					# send the timer to announce the ad at the adBufferTime and phase 1
					adTimerPhase = 1
					adLength = int(json["data"][0]["duration"])
					myAdTimer.start(adTimeDiff - adBufferTime)
					
			

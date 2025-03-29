extends Node2D

# required to validate tokens on launch and at least once hourly per twitch policy
@onready var userNode = get_tree().current_scene.find_child("User")
@onready var myTimer = $Timer

var timerPhase = 0

func _startup():
	print(util.prefix("B"), "Initialzing token validaiton controller.")
	$HTTPRequest.request_completed.connect(_on_request_completed)
	_on_timer_timeout()
		
func validateToken(token:String):
	var headers:PackedStringArray = ["Authorization: OAuth " + token]
	var _req = $HTTPRequest.request("https://id.twitch.tv/oauth2/validate", headers, HTTPClient.METHOD_GET)

func _on_request_completed(_result, _response_code, _headers, _body):	
	var jBody:Dictionary = JSON.parse_string(_body.get_string_from_utf8())
	if jBody.has("expires_in"):
		print(util.prefix("B"), "   ...Token validated. Expires in ", str(jBody["expires_in"]))
	else:
		print(util.prefix("B"), "   ...Token validation failed with response code ", str(_response_code))
		print(util.prefix("B"), "      ...and JSON response body; ", JSON.parse_string(_body.get_string_from_utf8()))

func _on_timer_timeout():
	timerPhase += 1
	
	if timerPhase == 1:
		print(util.prefix("B"), "Validating IRC token...")
		validateToken(userNode.bot_irc_token)
		
		myTimer.wait_time = 1
		myTimer.start()
		
	elif timerPhase == 2:
		print(util.prefix("B"), "Validating PubSub token...")
		validateToken(userNode.bot_pubsub_token)
		
		timerPhase = 0
		myTimer.wait_time = ((44 + randi_range(1, 11))*60) # set the timer to 45 - 55 minutes till another validation.
		myTimer.start()
		

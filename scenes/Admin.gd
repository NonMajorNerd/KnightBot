extends Node2D

var DEBUG:bool = true

@onready var masterController = get_tree().current_scene
@onready var userText = $Panel/UserText
@onready var eventList:MenuButton = $Panel/MenuButton


func _ready():
	eventList.get_popup().index_pressed.connect(event_list_changed)


func _on_list_users_pressed():
	#output masterusers and activeusers with Name (Owner)
	print("\n", util.prefix("B"), "MasterUsers")
	if masterController.myFileController.masterUsers.size() > 0:
		for character in masterController.myFileController.masterUsers:
			print(util.prefix("B"), "   ", character.characterData["name"], " (",character.characterData["owner"],")", " ",character.characterData["level"], " ",character.characterData["xp"])
	else:
		print(util.prefix("B"), "   No Master Users")
		
	print("\n", util.prefix("B"), "Active Users")
	if masterController.myFileController.activeUsers.size() > 0:
		for character in masterController.myFileController.activeUsers:
			print(util.prefix("B"), "   ", character.characterData["name"], " (",character.characterData["owner"],")")
	else:
		print(util.prefix("B"), "   No ActiveUsers")
	print("")


func _on_add_user_pressed():
	var userName:String = userText.text.strip_edges()
			
	#crtl+shift+add will delete a character from both the active and master users.
	if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_SHIFT):
		for user in masterController.myFileController.activeUsers: 
			if user.characterData["owner"] == userName:
				masterController.myFileController.activeUsers.erase(user)
				break
				
		for user in masterController.myFileController.masterUsers: 
			if user.characterData["owner"] == userName:
				masterController.myFileController.masterUsers.erase(user)
				break
	else:
		# look through master list for matching userstree
		for character in masterController.myFileController.masterUsers:
			if DEBUG: print(util.prefix("B"), "   ", character.characterData["name"], " (",character.characterData["owner"],")")
			if character.characterData["owner"] == userName:
				#if we find a matching user
				if DEBUG: print (util.prefix("B"), "   Matching MasterUser found for login ", userName, ".")
				var found: bool = false
				#if we have active users
				if masterController.myFileController.activeUsers.size() > 0:
					if DEBUG: print("\n", util.prefix("B"), " ActiveUsers")
					#we need to make sure this user is not already in ActiveUsers
					for user in masterController.myFileController.activeUsers: 
						if user.characterData["owner"] == userName:
							if DEBUG: print(util.prefix("B"), "   ", "Character already exists in ActiveUsers")
							found = true
							
				if not found:
					#if it wasnt in ActiveUsers, add it to ActiveUsers
					masterController.myFileController.activeUsers.append(character)
					if DEBUG: print (util.prefix("B"), "Character added to ActiveUsers")

		

func event_list_changed(_int=null):
	if _int != -1: eventList.text = eventList.get_popup().get_item_text(_int)
	else: eventList.text = "Select Event"


func _on_simulat_event_pressed():
	masterController.handleRedeem({"Title":eventList.text, "Login": userText.text.strip_edges(), "Input":""})

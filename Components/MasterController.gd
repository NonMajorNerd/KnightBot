extends Node2D

var DEBUG:bool = true

var phase = 0
var pathSaveLoad = "res://_ Data/CharacterData.dat"
var iconPhase = 0
var artifactPool:Array = []
var randNames:Array = []

@onready var myFileController:FileController = FileController.new() 
@onready var myEventSubController = $API/EventSub
@onready var myHelixController = $API/Helix
@onready var myIRCController = $API/IRC
@onready var myPubSubController = $API/PubSub
@onready var myValidationController = $API/TokenValidation

@onready var myFoMController = $"FoM Controller"
@onready var myTavernController = $Tavern
@onready var myNameGenerator = $NameGen
@onready var myTextAudioBrain = $TABrain
@onready var myAdminPanel = $Admin
@onready var myIconPanel = $"KB Slider Control"
@onready var myIconTimer = $"KB Slider Control/Timer"
@onready var myIconAnimator = $"KB Slider Control/AnimationPlayer"

# used to keep track of the inital on-save load
var preSaved = false

func GenerateArtifacts() -> Array:
	#generate artifacts. Each artifact has a % chance to 'spawn' each time the bot is ran. So not every artifact is obtainable at any given time.
	
	# scythe
	# sewing-needle
	# war-pick
	# lockpicks
	# spyglass
	# thor-hammer
	# enchanted-blade
	# cultists-dagger
	# runic-sword
	# relic-blade
	# meat-cleaver
	# poison-dagger
	# masterwork-dagger
	# rogues-cloak
	# paladins-helm
	# stiletto
	# spectacles
	# flaming-arrows
	# fake-beard
	# executioner-hood
	# steampunk-goggles
	# dwarven-crown
	# party-hat
	# top-hat
	# walther-ppk
	# skeleton-key
	# gauntlet
	# gloves
	# medium-armor
	# leather-armor
	# spiked-pauldrons
	# high-boots
	# boots
	# ivory-tusks
	# pet-hedgehog
	# breastplate
	# smoke-bomb
	# thrown-daggers
	# tomahawk
	# whip
	# feather
	# pocket-bacon
	# hunting-horn
	# paper-crane
	# throwing-star
	# horn-plenty
	# gold-scarab
	# booze
	# flail
	# jeweled-chalice
	# war-axe
	# rope-coil
	# medusa-head
	# ray-gun
	
	var results:Array = []
	
	# 100% chance artifacts
		# can only have one modifier of +/-1  
	if true:
		results.append(Artifact.new('Ancient Bust', 'a bust of the famous philosopher Borroni.', 'philosopher-bust', 100, 0, 0, 1))
		results.append(Artifact.new('Boots of Speed', 'leather boots adorned with magical wings.', 'wingfoot', 100, 0, 1, 0))
		results.append(Artifact.new('Spiked Club', 'a wooden club with vicious spikes at one end.', 'spiked-club', 100, 1, 0, 0))
		results.append(Artifact.new('Cracked Mask', 'a painted ceramic mask with a substantial crack.', 'cracked-mask', 100, 0, 0, 1))
		results.append(Artifact.new('Hunting Bolas', 'two stones on either end of interconnected cords.', 'hunting-bolas', 100, 0, 1, 0))
		results.append(Artifact.new('Stone Spear', 'a razor-sharp stone fixed to a long wooden handle.', 'stone-spear', 100, 1, 0, 0))
		results.append(Artifact.new('Tribal Pendant', 'a primitive necklace with a refined crystal pendant.', 'tribal-pendant', 100, 0, 0, 2))

	# 50% chance artifacts
	var spawn_chance = 50
	if true:
		# can have two modifiers of +/-1

		var spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: 	results.append(Artifact.new('Warlord Helmet', 'the menacing helmet of a dark knight.', 'warlord-helmet', 50, 1, 0, 1))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Round Shield', 'a sturdy oaken shield with an metal umbo.', 'wooden-shield', 50, 1, -1, 0))

		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Snake Totem', 'an ornate snake figurine hewn from cedar.', 'snake-totem', 50, 0, 1, 1))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Cracked Helmet', 'an iron helm with a substantial crack.', 'cracked-helm', 50, 1, 0, 1))

		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Loaded Dice', 'a set of dice which always come up 7.', 'loaded-dice', 50, -1, 1, 1)) 

		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Horned Helmet', 'an imposing helmet with two horns.', 'horned-helmet', 50, -1, 0, 1))

	# 25% chance artifacts
		# can have one modifier of +/-1 and one modifier of +/-2, 
		# or can have 3 modifiers of +/-1
	spawn_chance = 25
	if true:
		
		var spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Warrior Bust', 'a bust of the famous warrior Violetta.', 'stone-bust', 25, 2, -1, 0))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Elven Arrow', 'a magical arrow from an elven wode.', 'elven-arrow', 25, 0, 2, 1))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Wizard Staff', 'an arcane staff carved from gnarled wood.', 'wizard-staff', 25, -1, 0, 2))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Bone Knife', 'a sharp stone blade tied to some sort of bone.', 'bone-knife', 25, 1, 1, -1))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Battle Standard', 'a huge canvas banner proudly displaying a long forgotten standard.', 'battle-standard', 25, 1, 1, 1))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Long Bow', 'an ornately carved wooden war bow.', 'long-bow', 25, 0, 3, 0))
		
	# 10% chance artifacts
	spawn_chance = 10
	if true:
		
		var spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Traffic Cone', 'an orange and white traffic cone - safety first!', 'traffic-cone', 10, 0, -1, 1))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('All the Swords', 'almost certainly too many swords.', 'all-the-swords', 10, 3, -1, -1))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Beehive', '.. Oops, all bees!', 'beehive', 10, -1, -1, -1))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Hide Armor', 'simple armor made of rough animal skins and furs.', 'hide-armor', 10, 1, 1, -1))
		
		spawn_roll = randi_range(1,100)
		if spawn_roll <= spawn_chance: results.append(Artifact.new('Bat Mask', 'a strange dark-blue mask with pointed ears.', 'bat-mask', 10, 2, 1, -2))

	return results

func _on_timer_timeout(): #myIconTimer Timeout
	iconPhase += 1
	
	if iconPhase == 1:
		myIconAnimator.play("slide")
		myIconTimer.wait_time = 3
		myIconTimer.start()
		
	elif iconPhase == 2:
		myIconAnimator.play("bounce")
		myIconTimer.wait_time = 1.5
		myIconTimer.start()
		
	elif iconPhase == 3:
		myIconAnimator.play_backwards("bounce")
		myIconTimer.wait_time = 2
		myIconTimer.start()
		
	elif iconPhase == 4:
		iconPhase = 0
		myIconAnimator.play_backwards("slide")
		#the first time this plays, aka on launch, we pre-save the data to make backups
		if not preSaved:
			preSaved = true
			myFileController.SaveToJSON(pathSaveLoad)
			
		myIconTimer.wait_time = 600 + (30 * randi_range(1,20)) # 10 to 20 minutes between showing again
		myIconTimer.start()
		
#check for input
func _process(_delta):
	if Input.is_action_just_released("toggleDebug"): myAdminPanel.visible = !myAdminPanel.visible


func _ready():
	
	DisplayServer.window_set_position(DisplayServer.window_get_position() + Vector2i(0, 40))
	
	myFileController.LoadFromJSON(pathSaveLoad)
	myIRCController._startup()
	myPubSubController._startup()
	myValidationController._startup()
	
	artifactPool = GenerateArtifacts()
	
	myAdminPanel.visible = false
	
	for artifact in artifactPool:
		print(util.prefix("B") + str(artifact.data['artName']) + " (" + str(artifact.data['spawn_chance']) +")")
	print("\n")
	
#	var newChar = Character.new("nottthebrave", "NottTheBrave")
#	newChar.characterData["owner"] = "nottthebrave" #"nott_thebrave24"
#	newChar.characterData["name"] = "NottTheBrave"
#	newChar.characterData["gp"] = 150
#	newChar.characterData["base_fortitude"] = 10
#	newChar.characterData["base_reflex"] = 12
#	newChar.characterData["base_willpower"] = 13
#	newChar.characterData["archetype"] = "Healer"
#	newChar.characterData["archetype_rating"] = 2
#	myFileController.masterUsers.append(newChar)
#
#	var myChar = Character.new("nonmajornerd", "Valafar")
#	myChar.characterData["owner"] = "nonmajornerd" #"nott_thebrave24"
#	myChar.characterData["name"] = "Valafar"
#	myChar.characterData["gp"] = 1500
#	myChar.characterData["base_fortitude"] = 18
#	myChar.characterData["base_reflex"] = 18
#	myChar.characterData["base_willpower"] = 18
#	myFileController.masterUsers.append(myChar)

#this signal gets sent up from the IRC API
func handleJoin(joinLogin:String):
	if DEBUG: print (util.prefix("B"), "Handling join for login ", joinLogin, ".")
	# look through master list for matching character
	var foundMasterChar:Character = myFileController.getCharacterFromOwner(joinLogin, myFileController.masterUsers)
	
	if foundMasterChar != null: #we found a matching character
		if DEBUG: print (util.prefix("B"), "   ...Matching MasterUser found.")
		#look through active list for matching character
		var foundActiveChar:Character = myFileController.getCharacterFromOwner(joinLogin, myFileController.activeUsers)
		
		if foundActiveChar != null: #character already exists in active users
			if DEBUG: print(util.prefix("B"), "      ...Character already exists in ActiveUsers.")
		else:
			#add the character from the MasterUsers list to ActiveUsers
			myFileController.activeUsers.append(foundMasterChar)
			if DEBUG: print(util.prefix("B"), "      ...Character added to ActiveUsers.")
	else: if DEBUG: print(util.prefix("B"), "   ...No matching MasterUser found.")

#this signal gets sent up from the IRC API
func handlePart(partLogin:String):
	# Move a user from ActiveUser to MasterUser
	#do we take this time to update the masteruser list and save everything? 
	#make sure we're not further altering the activeusers list if so
	if DEBUG: print (util.prefix("B"), "Handling part for login ", partLogin, ".")

#this signal gets sent up from the Character class
func handleLevel(levelChar:Character):
	myIRCController.send_data("PRIVMSG #nonmajornerd : " + levelChar.characterData['name'] + " has grown to level " + str(levelChar.characterData['level']) + "!")

#this signal gets sent up from the IRC API to handle chat messages which do not contain commands
func handleChat(sender:String, message:String):
	var data:Array = [sender, message]
	if myTextAudioBrain.process_mode != PROCESS_MODE_DISABLED: myTextAudioBrain.readChat(data)

func TAB_sendChat(chat:String=""):
	if chat != "": myIRCController.send_data("PRIVMSG #nonmajornerd : " + chat)
	
func hostTavern():
	# this is in its own function so that it can be called by the Helix controller related to ad breaks
	var rewards = {}
	rewards = myTavernController.GenerateTavern(myFileController.activeUsers)

	myIRCController.send_data("PRIVMSG #nonmajornerd : " + rewards['tavern'])
	myHelixController.taverned = true # disable the automatic pre-ad tavern
	
	if myFileController.activeUsers.size() > 0:
		for tavernChar in myFileController.activeUsers:
			tavernChar.characterData['xp'] += rewards['xp_reward']
			var leveled = tavernChar.CheckLevel() 
			if leveled: handleLevel(tavernChar)
			myFileController.SaveToJSON(pathSaveLoad)
	
#this signal gets sent up from the IRC API to handle chat messages which contain commands
func handleCommand(sender:String, command:String, args:String=""):
	if command.length() > 0:
		command = command.strip_edges().to_lower()
		if DEBUG: print(util.prefix("B"), "Command handled from user ", sender, "; ", command, "(", args, ")")
		
		#########################
		# Chat/Bot Commands
		#########################
		
		if command in ["artifacts", "pool"]:
			var arts = []
			var results = "The artifact pool currently contains "
			
			for artifact in artifactPool:
				if artifact.data["spawn_chance"] < 100:
					arts.append(str(artifact.data['artName']))

			if artifactPool.size() == 0:
				results = "zero Artifacts whatsoever!"
			elif arts.size() == 0:
				results = "only Guaranteed Artifacts."
			elif arts.size() == 1 :
				results = "only the " + arts[0]
			else:
				arts.sort()
				
				for i in  range (arts.size()):
					if i > 0 and arts.size() > 2: results += ", "
					if i+1 == arts.size(): results += " and "
					results += arts[i]
			
			myIRCController.send_data("PRIVMSG #nonmajornerd : "  + results + ".")
			
		# commands specific to Brackeys Game Jam 2025.1
		elif command in ["brackeys", "gamejam", "game", "jam"]:
			myIRCController.send_data("PRIVMSG #nonmajornerd : " + "We're making a game in Godot 4.2 for Brackeys Game Jam 2025.1! We're collaborating with @DarthJaper, @Galanith, @NixxVT, and @Soapy_Sharkk!")
			
		elif command in ["bucket", "buckets"]:
			myTextAudioBrain.getAboutBuckets()
		
		elif command in ["intro", "introduce", "kb", "knightbot"]:
			myIRCController.send_data("PRIVMSG #nonmajornerd : " + "KnightBot primarily functions as an announcer for the Channel Points RPG. You can create a Character, hunt for Artifacts, and compete against your friends right here in the twitch chat! More info at https://nonmajornerd.github.io/knightbot.html")
			myTextAudioBrain.getIntro()
			
		elif command in ["insult", "roastme"]:
			myTextAudioBrain.getInsult()
			
		elif command in ["jail", "crime", "crimes"]:
			myTextAudioBrain.getCrimes()
			
		elif command in ["pro", "professional", "prostreamer", "professionalstreamer"]:
			myTextAudioBrain.getPro()
			
			
		#########################
		# Event-Related Commands
		#########################
		
		elif sender == "nonmajornerd" and command == "tavern":
			hostTavern()
		
		elif command in ["mycharacter", "character", "mychar", "mchar", "char", "mc"]:

			var foundChar:Character = myFileController.getCharacterFromOwner(sender.to_lower(), myFileController.activeUsers)
			if foundChar != null:
				if DEBUG: print(util.prefix("B"), "Character ", foundChar.characterData["name"], " found for !MyCharacter command.")
				var thisShowChar = preload("res://scenes/ShowChar/ShowChar.tscn").instantiate()
				get_tree().current_scene.add_child(thisShowChar)
				thisShowChar.setup(foundChar)
				myIRCController.send_data("PRIVMSG #nonmajornerd : Allow me to introduce " + foundChar.getDescription())

			else:
				if DEBUG: print(util.prefix("B"), "No ActiveUsers for !MyCharacter command.")
				myIRCController.send_data("PRIVMSG #nonmajornerd : " + str(sender) + " you have no active character!")

		elif command in ['rename', 'rname', 'name', "rn"]:
			var foundChar:Character = myFileController.getCharacterFromOwner(sender.to_lower(), myFileController.activeUsers)
			if foundChar != null:
				var oldname = foundChar.characterData["name"]
				var newname = args
				print(str(newname).to_upper())
				if newname.to_upper() in ["", "R", "RAND", "RANDO", "RANDOM" ]:
					newname = myNameGenerator.getName()
				
				if newname.length() > 14: newname = newname.substr(0,14)	
				
				foundChar.characterData["name"] = newname
				myIRCController.send_data("PRIVMSG #nonmajornerd : " + foundChar.characterData["owner"] + " you have changed your characters name from " + oldname + " to " + foundChar.characterData["name"] + "!")
				myFileController.SaveToJSON(pathSaveLoad)
			else:
				if DEBUG: print(util.prefix("B"), "No ActiveUsers for !rename command.")
				myIRCController.send_data("PRIVMSG #nonmajornerd : " + str(sender) + " you have no active character!")
				
		elif command in ["replacearchetype", "replacearch", "rarchetype", "rarch"]:
			#command to replace primary archetype with the archetype stored in tempArch

			var foundChar:Character = myFileController.getCharacterFromOwner(sender.to_lower(), myFileController.activeUsers)

			if foundChar != null:
				if DEBUG: print(util.prefix("B"), "Character ", foundChar.characterData["name"], " found for !ReplaceArchetype command.")

				if foundChar.characterData["tempArch"] != "null":
					myIRCController.send_data("PRIVMSG #nonmajornerd : " + foundChar.characterData["owner"] + " you have chosen to replace your current archetype (" + foundChar.characterData["archetype"] + ") with your rolled archetype (" + foundChar.characterData["tempArch"] + ")!")
					foundChar.characterData["archetype"] = foundChar.characterData["tempArch"]
					foundChar.characterData["archetype_rating"] = foundChar.characterData["tempArchRating"]
					foundChar.characterData["tempArch"] = "null"
					foundChar.characterData["tempArchRating"] = 0
					myFileController.SaveToJSON(pathSaveLoad)
				else:
					myIRCController.send_data("PRIVMSG #nonmajornerd : " + foundChar.characterData["owner"] + " you have not rolled for an additional archetype.")


		elif command in ["keeparchetype", "keeparch", "karchetype", "karch"]:
			#command to keep primary archetype and erase any temp archetype
			if myFileController.activeUsers.size() > 0:
				for activeChar in myFileController.activeUsers:
					if DEBUG: print(util.prefix("B"), "   ", activeChar.characterData["name"], " (", activeChar.characterData["owner"], ")")
					if activeChar.characterData["owner"] == sender.to_lower():
						if DEBUG: print(util.prefix("B"), "Character ", activeChar.characterData["name"], " found for !KeepArchetype command.")
						myIRCController.send_data("PRIVMSG #nonmajornerd : " + activeChar.characterData["owner"] + " you have chosen to keep your current archetype (" + activeChar.characterData["archetype"] + ").")
						activeChar.characterData["tempArch"] = "null"
						activeChar.characterData["tempArchRating"] = 0
						myFileController.SaveToJSON(pathSaveLoad)
			else:
				if DEBUG: print(util.prefix("B"), "No ActiveUsers for !KeepArchetype command.")
				myIRCController.send_data("PRIVMSG #nonmajornerd : " + str(sender) + " you have no active character!")
				
		elif command in ["replaceartifact", "replaceart", "rartfact", "rart"]:
			#command to replace primary artifact with the artifact stored in tempArtifact

			var foundChar:Character = myFileController.getCharacterFromOwner(sender.to_lower(), myFileController.activeUsers)

			if foundChar != null:
				if DEBUG: print(util.prefix("B"), "Character ", foundChar.characterData["name"], " found for !ReplaceArtifact command.")

				if foundChar.characterData["tempArtifact"] != {}:
					myIRCController.send_data("PRIVMSG #nonmajornerd : " + foundChar.characterData["owner"] + " you have chosen to replace your current artifact (" + foundChar.characterData["artifact"]["artName"] + ") with your newly-found artifact (" + foundChar.characterData["tempArtifact"]["artName"] + ")!")
					foundChar.characterData["artifact"] = foundChar.characterData["tempArtifact"]
					foundChar.characterData["tempArch"] = {}
					myFileController.SaveToJSON(pathSaveLoad)
				else:
					myIRCController.send_data("PRIVMSG #nonmajornerd : " + foundChar.characterData["owner"] + " you have not located an additional artifact.")
					
		elif command in ["keepartifact", "keepart", "kartifact", "kart"]:
			#command to keep primary archetype and erase any temp archetype
			if myFileController.activeUsers.size() > 0:
				for activeChar in myFileController.activeUsers:
					if DEBUG: print(util.prefix("B"), "   ", activeChar.characterData["name"], " (", activeChar.characterData["owner"], ")")
					if activeChar.characterData["owner"] == sender.to_lower():
						if DEBUG: print(util.prefix("B"), "Character ", activeChar.characterData["name"], " found for !KeepArchetype command.")
						if activeChar.characterData["artifact"].size() > 0:
							myIRCController.send_data("PRIVMSG #nonmajornerd : " + activeChar.characterData["owner"] + " you have chosen to keep your current artifact (" + activeChar.characterData["artifact"]["artName"] + ").")
							activeChar.characterData["tempArtifact"] = {}
							myFileController.SaveToJSON(pathSaveLoad)
						else:
							myIRCController.send_data("PRIVMSG #nonmajornerd : " + activeChar.characterData["owner"] + " you have not yet found any artifacts.")
							

#this signal gets sent up from the PubSub API
func handleRedeem(redemption:Dictionary): #redemption =  {"Title":pubRewardTitle, "Login":pubUserLogin, "Input":pubUserInput}
	if DEBUG: print(util.prefix("B"), str(redemption).to_lower())
	
	if redemption["Title"].contains("First"):
		#Call the Text and Audio lines for this redeem
		myTextAudioBrain.getFirst() 
	
	elif redemption["Title"].contains("New Character"):
	
		#look for existing character for this login
		var foundChar:Character = myFileController.getCharacterFromOwner(redemption["Login"].to_lower(), myFileController.masterUsers)
		
		#no master character found
		if foundChar == null:

			if DEBUG: print(util.prefix("B"), "Creating new character")
			
			#Call the Text and Audio lines for this redeem
			myTextAudioBrain.getNewChar()
			await get_tree().create_timer(2).timeout

			#assign or generate name, trim down to 14 or fewer characters
			var charName:String = redemption["Input"]
			if charName.to_upper() in ["", "R", "RAND", "RANDO", "RANDOM" ]:
				charName = myNameGenerator.getName()
			if charName.length() > 14: charName = charName.substr(0,14)

			var newChar = Character.new(redemption["Login"], charName)

			var sceneNewChar:PackedScene = load("res://scenes/NewChar/NewChar.tscn")
			var thisNC = sceneNewChar.instantiate()
			thisNC.myNewChar = newChar
			get_tree().current_scene.add_child(thisNC)
			await get_tree().create_timer(23).timeout
			myFileController.activeUsers.append(newChar)
			myFileController.masterUsers.append(newChar)
			myFileController.updateMaster()
			myFileController.SaveToJSON(pathSaveLoad)
			if DEBUG: for user in myFileController.activeUsers: print(util.prefix("B"), user.characterData["name"])
			
		else:
			if DEBUG: print(util.prefix("B"), "TODO :: Handle existing master user for new character.")
			myIRCController.send_data("PRIVMSG #nonmajornerd : " + redemption['Login'] + " you already have an active character!")

	elif redemption["Title"].contains("Archetype"):
		#look for existing character for this login
		var foundChar:Character = myFileController.getCharacterFromOwner(redemption["Login"].to_lower(), myFileController.activeUsers)
		
		if foundChar == null: #no active user found, check master users
			foundChar = myFileController.getCharacterFromOwner(redemption["Login"].to_lower(), myFileController.masterUsers)
			#if we find a masteruser, add them to activeuser and continue. 
			if foundChar != null: myFileController.activeUsers.append(foundChar) #this needs to stay separate from the below check to work properly
		
		#no master character found
		if foundChar != null:
			#Call the Text and Audio lines for this redeem
			myTextAudioBrain.getArchetype()
			await get_tree().create_timer(2).timeout
			
			#character found, instanciate roll_arch scene
			var thisArch:PackedScene = load("res://scenes/Roll Archetype/roll_archetype.tscn")
			var rollArch = thisArch.instantiate()
			get_tree().current_scene.add_child(rollArch)
			rollArch.setup(foundChar)
			await get_tree().create_timer(8).timeout
			myFileController.SaveToJSON(pathSaveLoad)
		else:
			myIRCController.send_data("PRIVMSG #nonmajornerd : " + redemption["Login"] + " you do not have an active character!")

	elif redemption["Title"].contains("Public Event"):
		pass

	elif redemption["Title"].contains("Artifact Map"):
		
		if artifactPool.size() < 1:
			myIRCController.send_data("PRIVMSG #nonmajornerd : " + redemption["Login"] + " all available artifacts have been located!")
		else:

			var artChar = myFileController.getCharacterFromOwner(redemption["Login"].to_lower(), myFileController.activeUsers)

			if artChar == null:
				myIRCController.send_data("PRIVMSG #nonmajornerd : " + redemption["Login"] + " you do not have an active character!")
			else:			
				if artChar.characterData["gp"] < 44:
					myIRCController.send_data("PRIVMSG #nonmajornerd : " + redemption["Login"] + " you approach the lore master to purchase an Artifact Map when you remember you're a few coins short. || (" + str(artChar.characterData["gp"]) + "/44gp)" )
				else:
					
					#Call the Text and Audio lines for this redeem
					myTextAudioBrain.getArtifactMap()
					await get_tree().create_timer(2).timeout
					
					#Set up and instanciate the artifact map scene
					var results:Dictionary = {}
					
					var rollArtScene = load("res://scenes/Roll Artifact/roll_artifact.tscn").instantiate()
					get_tree().current_scene.add_child(rollArtScene)
					results = rollArtScene.rollForArtifact(artChar)
					await get_tree().create_timer(8).timeout
					
					if results["found"] == true:
						if artChar.characterData["tempArtifact"].size() > 0:
							myIRCController.send_data("PRIVMSG #nonmajornerd : You follow the map, and after several days of searching you find " + artChar.characterData["tempArtifact"]["artDesc"] + " || Your journey awards you " + str(results["xp"]) + "xp." )
						elif artChar.characterData["artifact"].size() > 0:
							myIRCController.send_data("PRIVMSG #nonmajornerd : You follow the map, and after several days of searching you find " + artChar.characterData["artifact"]["artDesc"] + " || Your journey awards you " + str(results["xp"]) + "xp." )
						else:
							#somehow we've rolled and found an artifact, but have no temp or primary artifact.
							print("dafuq?!?! somethings broken in the roll_artifact scene")
						
						artChar.characterData["xp"] += results["xp"]
						var leveled = artChar.CheckLevel() 
						if leveled: handleLevel(artChar)
						myFileController.SaveToJSON(pathSaveLoad)
						
					else:
						myIRCController.send_data("PRIVMSG #nonmajornerd : " + redemption["Login"] + " you follow the map, but after several days of searching you still are not able to locate an artifact! || Your journey awards you " + str(results["xp"]) + "xp." )
	
	elif redemption["Title"].contains("Feats of Mastery"):
		var a:String = "abcde"
		a.contains("q")
		#look for existing character for this login
		var foundChar:Character = myFileController.getCharacterFromOwner(redemption["Login"].to_lower(), myFileController.activeUsers)

		if foundChar != null: #character found
			var results = {}
			results = await myFoMController.addParticipant(foundChar)
			
			# the FoM controller only returns data once it has completed all steps for an event
			if results.size() > 0:
				results["winner"].characterData["xp"] += 20
				results["winner"].characterData["gp"] += 30
				var leveled = results["winner"].CheckLevel() 
				if leveled: handleLevel(results["winner"])
				
				results["p1"].characterData["xp"] += 10
				leveled = results["p1"].CheckLevel() 
				if leveled: handleLevel(results["p1"])
				
				results["p2"].characterData["xp"] += 10
				leveled = results["p2"].CheckLevel() 
				if leveled: handleLevel(results["p2"])
				myFileController.SaveToJSON(pathSaveLoad)
				
		else:
			if DEBUG: print(util.prefix("B"), " No active character found for FoM")
			myIRCController.send_data("PRIVMSG #nonmajornerd : " + redemption['Login'] + " you do not have an active character!")	

func _on_load_user_pressed():
	var charname:String = $"Admin/Panel2/UserText".text.strip_edges()
	var card:CharacterCard = $"Admin/Panel2/CharacterCard"
	
	#look for existing character for this login
	var foundChar:Character = myFileController.getCharacterFromOwner(charname.to_lower(), myFileController.masterUsers)
	
	if foundChar != null: #no active user found, check master users
		card.showCharacter(foundChar)

extends Node2D

var DEBUG:bool = true

var fitChance:int = 0
var bucketsInChat:int = 0
var bucketYells: int = 0

@onready var myController = get_parent()
@onready var myAudio = $AudioStreamPlayer2D
@onready var myAnimation = $AnimationPlayer
@onready var myTimer = $Timer

var guestsgreeted = {}

var intros = {
	"INTRO_AdvisorAndCounsel.mp3": 		"I am KnightBot, loyal advisor and counselor to NonMajorNerd.",
	"INTRO_Buckets.mp3":				"I am KnightBot. I serve NonMajorNerd and help to keep chat from talking about buckets.",
	"INTRO_KeepChatinLine.mp3":			"I am KnightBot. I announce events and help keep chat in line.",
	"INTRO_GuardThisChannel.mp3":		"I am KnightBot. I used to guard Whiterun from buket crimes. Now, I guard this channel."
	}

var named_greetings = {
	"americanelm" : 	"The one and only AmericanElm. Great to see you, old friend.",
	"blindirl" : 		"BlindIRL, great to have you. Welcome.",
	"darthjaper" : 		"Ahh, our friend DarthJaper is here. Welcome.",
	"galanith" : 		"Galanith, my friend, good to see you.",
	"metarract" : 		"It's a bird, it's a plane, it's Metarract! Thank you for coming. ... Wait. What is a plane?",
	#"nonmajornerd" : 	"I'm not sure why you're talking to me through chat, but hello NonMajorNerd",
	"nottthebrave" : 	"Ahh look, it's NottTheBrave. Good to see you, friend.",
	"seven727" : 		"How wonderful, our friend Seven727 is here. Good to see you."
}

var named_greetings_voicelines = {
	"americanelm" : 	"Greeting_AmericanElm.mp3",
	"blindirl" : 		"Greeting_BlindIRL.mp3",
	"darthjaper" : 		"Greeting_DarthJaper.mp3",
	"galanith" : 		"Greeting_Galanith.mp3",
	"metarract" : 		"Greeting_Metarract.mp3",
	#"nonmajornerd" : 	"Greeting_NonMajorNerd.mp3",
	"nottthebrave" : 	"Greeting_NottTheBrave.mp3",
	"seven727" : 		"Greeting_Seven.mp3"
}

var greetings = {
	"GREETING_GreatToSeeYou.mp3" : 	"Hello, great to see you.",
	"GREETING_HelloThere.mp3" : 	"Hello there.",
	"GREETING_WelcomeFriend.mp3" : 	"Welcome, friend."
}

var about_buckets = {
	"MISC_BUCKETS_COMMAND_DefenselessNPCs.mp3":	"You will not convince me that anybody actually needs a bucket. The only thing buckets are used for is stealing from poor defenseless NPCs.",
	"MISC_BUCKETS_COMMAND_ToolOfCrime.mp3":		"Buckets are a tool of crime, used to take advantage of NPCs who don't know any better.",
	"MISC_BUCKETS_StrictNoBuckets.mp3":			"This is a strict 'No Buckets' zone."
}

var buckets = {
	"MISC_BUCKETS_PleaseDoNot.mp3":		"Please do not talk about putting buckets on peoples heads.",
	"MISC_BUCKETS_PleaseRefrain.mp3": 	"Please refrain from talking about buckets in the chat.",
	"MISC_BUCKETS_PleaseStop.mp3": 		"Please stop talking about buckets.",
	"MISC_BUCKETS_StrictNoBuckets.mp3":	"This is a strict 'No Buckets' zone."
	}

var insults = {
	"MISC_INSULT_ATree.mp3": 			"Somewhere out there a tree is producing oxygen.. for you. What a shame.",
	"MISC_INSULT_BattleOfWits.mp3": 	"I will not engage in a battle of wits against an unarmed opponent.",
	"MISC_INSULT_Before.mp3": 			"You look like a 'before' picture.",
	"MISC_INSULT_DogFlower.mp3":		"If I were a dog and you were a flower, I'd lift up my leg and give you a shower.",
	"MISC_INSULT_GardenHose.mp3":		"You are a slimy garden hose of a man.",
	"MISC_INSULT_GoFar.mp3":			"You will go far one day, and I hope that you stay there.",
	"MISC_INSULT_RollingYourEyes.mp3":	"Rolling your eyes isn't going to help you find your brain.",
	"MISC_INSULT_TwoBraincells.mp3":	"You've only got two brain cells - and both of them are fighting for third place."
	#"MISC_INSULT_YourFather.mp3":		"Your father smelled of elderberries.",
	#"MISC_INSULT_YourMother.mp3":		"Your mother was a hamster."
	}

var banned = {
	"BAN_OrderOfJarl.mp3":			"By order of the Jarl; you're banned!"
}

var timeouts = {
	"NO_IdRatherNot.mp3":			"I'd rather not.",
	"TIMER_AnotherTime.mp3":		"Another time, perhaps.",
	"TIMER_PleaseNotNow.mp3":		"Please, not now."
}

var pro = {
	"MISC_NMNProStreamer.mp3": 			"NonMajorNerd is what they call a 'Pro Streamer'.",
	#"MISC_CertifiedPro.mp3":			"Sir NonMajorNerd is a certified 'Pro Gamer'.",
	"MISC_ConsummateProfessional.mp3": 	"NonMajorNerd is a.. consummate professional."
}

var KB_FoMStart = {
	"FOM_START_ChampionsSharpenBlades.mp3":	"Champions, sharpen your blades and steel your resolve! The Feats of Mastery are about to commence!",
	"FOM_START_SwordsClash.mp3":			"Swords will clash and spells will ignite! Brace yourselves for the ultimate challenge!",
	"FOM_START_LadiesAndGentlemen.mp3":		"Ladies and gentlemen, the moment you've all been waiting for - the grand spectacle of skill and bravery – Feats of Mastery!",
	"FOM_START_WelcomeOneAndAll.mp3":		"Welcome, one and all, to the thrill and splendor of Feats of Mastery!",
	"FOM_START_ProveYourWorth.mp3":			"Let the challenge begin! Sharpen your blades, charge your spells, and prove your worth!",
	"FOM_START_LegendsWillBeBorn.mp3":		"Brace yourselves, for within these trials, heroes will rise and legends will be born!"
}

var Redemptions_First = {
	"REDEMPTIONS_FIRST_Congratulations.mp3":		"Congratulations, you're the first one here.",
	"REDEMPTIONS_FIRST_ExcitedOrEmbarrassed.mp3":	"You're the first one here - I'm not sure if you should be excited, or embarrassed."
}

var Redemptions_KB_NewChar = {
	"REDEMPTIONS_KB_NEWCHAR_NewestAdventurer.mp3": 			"Looks like we have an addition to the camp. Let's meet our newest adventurer.",
	"REDEMPTIONS_KB_NEWCHAR_NewAdventurerApproaches.mp3": 	"A new adventurer approaches! Let's see what they bring to the table.",
	"REDEMPTIONS_KB_NEWCHAR_FortuneHunter.mp3": 			"Looks like we have a new fortune hunter. Let's see what they're made of."
}

var Redemptions_KB_FomFirstTicket = {
	"REDEMPTIONS_KB_FOM_AFOMChallengeOpened.mp3": "A Feats of Mastery challenge has been opened!"
}

var Redemptions_KB_FoMTicket = {
	"REDEMPTIONS_KB_FOM_AnotherFOMTicket.mp3": 		"Another Feats of Mastery ticket has been purchased.",
	"REDEMPTIONS_KB_FOM_AFOMTicketPurchased.mp3": 	"A feats of mastery ticket has been purchased.",
}

var Redemptions_KB_FoMFinalTicket = {
	"REDEMPTIONS_KB_FOM_FinalFOM.mp3": "The final Feats of Mastery ticket has been purchased!"
}

var Redemptions_KB_Artifact = {
	"REDEMPTIONS_KB_ART_WhatTreasures.mp3": 		"Let's see what treasures this Artifact Map tells of.",
	"REDEMPTIONS_KB_ART_WhatMysteries.mp3": 		"What mysteries might this Artifact Map reveal?",
	"REDEMPTIONS_KB_ART_ArtMapPurchasedBOL.mp3": 	"An Artifact Map has been purchased! Best of luck."
}

var Redemptions_KB_Archetype = {
	"REDEMPTIONS_KB_ARCHETYPE_Quartermaster.mp3": 	"Someone is speaking with the Quartermaster. Let's see what they come back with.",
	"REDEMPTIONS_KB_ARCHETYPE_NewGear.mp3": 		"Looks like someone is on the hunt for some new gear."
}

func _ready():
	for key in named_greetings:
		guestsgreeted[key] = false

#func _on_timer_timeout():
	#the default behavior of timers in godot seems to be to continue running in loops
	#from WaitTime to 0 unless you specifically tell it to stop
	#myTimer.stop()
	
func getRandom(from:Dictionary) -> Array:
	var results = ["", ""]
	
	if from.size() > 0:
		var myChoice:String = from.keys().pick_random()
		
		results[0] = myChoice
		results[1] = from.get(myChoice)

	return results

func audioLoadAndPlay(path:String):
	var myPath = "res://_ Assets/sfx/Voiceovers/" + path
	print(str(myPath))
	myAudio.stream = load(myPath)
	myAudio.play()
	
func handle_event(event:Array =[]):
	if event[0] != "": audioLoadAndPlay(event[0])
	if event[1] != "": myController.TAB_sendChat(event[1])

func readChat(data:Array):
	var sender:String = data[0]
	var message:String = data[1]
	if DEBUG: print(util.prefix("B"), str(myTimer.wait_time), " seconds left on timer")
	if DEBUG: print(util.prefix("B"), "Chat handled from user ", sender, "; ", message)
	
	if message.to_lower().contains("bucket"):
		checkBuckets()
	else:
		if guestsgreeted.has(sender):
			if not guestsgreeted[sender]:
				handle_event([named_greetings_voicelines[sender], named_greetings[sender]])	
				guestsgreeted[sender] = true

func checkBuckets():
	bucketsInChat += 1
	if DEBUG: print(util.prefix("B"), "Another damned bucket. That makes ", str(bucketsInChat))
	
	var chance = 20 + (bucketsInChat * 20)
	var roll = randi_range(1, 100)
	
	if DEBUG: print(util.prefix("B"), str(chance), "     chance vs roll of ", str(roll))
	
	if chance >= roll:
		if DEBUG: print(util.prefix("B"), str(chance), "     time to yell about buckets")
		yellAboutBuckets()

func yellAboutBuckets():
	var data:Array = []
	var timerTime:float = 15.0
	
	if myTimer.time_left < 1:
		if DEBUG: print(util.prefix("B"), "     yelling about buckets")
		
		if bucketYells < 2:
			data = getRandom(buckets)
			bucketsInChat = 0
			
		elif bucketYells < 3:
			data = ["res://_ Assets/sfx/Voiceovers/MISC_BUCKETS_Guards.mp3", "If one more person mentions buckets, I'm calling the guards."]
			bucketsInChat = 1000
			
		else:
			data = ["res://_ Assets/sfx/Voiceovers/MISC_BUCKETS_BucketRelatedCrimes.mp3", "Alright, that's it. Guards! Arrest these hooligans for bucket-related crimes against the King."]
			bucketsInChat = 0
			bucketYells = 0
			timerTime = 30.0
				
		if bucketYells < 4:
			myAnimation.play("NoBuckets_Fade")
			
		bucketYells += 1
		handle_event(data)
		myTimer.start(timerTime)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		
func getAboutBuckets():
	var data:Array = ["", ""]
	
	if myTimer.time_left < 1:
		data = getRandom(about_buckets)
		myAnimation.play("NoBuckets_Fade")
		myTimer.start(15.0)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))	
		
	handle_event(data)
		
func getCrimes():
	var data:Array = ["", ""]
	
	if myTimer.time_left < 1:
		data = ["res://_ Assets/sfx/Voiceovers/MISC_JailForCrimes.mp3", "You're going to jail. For crimes!"]
		myTimer.start(15.0)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
			
	handle_event(data)
		
func getInsult():
	var data:Array = ["", ""]

	if myTimer.time_left < 1:
		data = getRandom(insults)
		myTimer.start(45.0)
	else:
		if randi_range(1,3) == 1: 
			data = getRandom(timeouts)
			
	handle_event(data)
	
	
func getIntro():
	var data:Array = ["", ""]
	
	if myTimer.time_left < 1:
		data = getRandom(intros)
		myTimer.start(15.0)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		if randi_range(1,3) == 1: 
			data = getRandom(timeouts)

	#disabling intros for now
	handle_event(data)
	
func getPro():
	var data:Array = ["", ""]
	
	if myTimer.time_left < 1:
		data = getRandom(pro)
		myTimer.start(15.0)
		myAnimation.play("Pro_Fade")
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		
	handle_event(data)

func getFirst():
	var data:Array = ["", ""]

	if myTimer.time_left < 1:
		data = getRandom(Redemptions_First)
		myTimer.start(15.0)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		
	handle_event(data)
	
func getNewChar():
	var data:Array = ["", ""]

	if myTimer.time_left < 1:
		data = getRandom(Redemptions_KB_NewChar)
		myTimer.start(15.0)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		
	handle_event(data)	
	
func getArtifactMap():
	var data:Array = ["", ""]

	if myTimer.time_left < 1:
		data = getRandom(Redemptions_KB_Artifact)
		myTimer.start(15.0)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		
	handle_event(data)	
	
func getArchetype():
	var data:Array = ["", ""]

	if myTimer.time_left < 1:
		data = getRandom(Redemptions_KB_Archetype)
		myTimer.start(15.0)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		
	handle_event(data)	
	
func getFirstFoMTicket():
	var data:Array = ["", ""]

	if myTimer.time_left < 1:
		data = getRandom(Redemptions_KB_FomFirstTicket)
		myTimer.start(15.0)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		
	handle_event(data)
	
func getFoMTicket():
	var data:Array = ["", ""]

	if myTimer.time_left < 1:
		data = getRandom(Redemptions_KB_FoMTicket)
		myTimer.start(15.0)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		
	handle_event(data)
	
func getFinalFoMTicket():
	var data:Array = ["", ""]

	if myTimer.time_left < 1:
		data = getRandom(Redemptions_KB_FoMFinalTicket)
		myTimer.start(0.5)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		
	handle_event(data)
	
func getFoMStart():
	var data:Array = ["", ""]

	if myTimer.time_left < 1:
		data = getRandom(KB_FoMStart)
		myTimer.start(15.0)
	else:
		if DEBUG: print(util.prefix("B"), "cooldown: ", str(myTimer.time_left))
		
	handle_event(data)

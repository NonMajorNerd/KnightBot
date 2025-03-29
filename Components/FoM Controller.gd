extends Node2D

@onready var IRCController = get_tree().current_scene.find_child("IRC")
@onready var myTABrain = get_tree().current_scene.find_child("TABrain")
@onready var myAnimator = $AnimationPlayer
@onready var myAudio = $AudioStreamPlayer2D
@onready var myEventAudio = $"Event Control/AudioStreamPlayer2D"
@onready var myEventSFX = $"Event Control/AudioStreamPlayer2D2"

@onready var ticketControl = $Control
@onready var eventControl = $"Event Control"
@onready var participantContainer = $"Event Control/Participants"
@onready var participant1 = $"Event Control/Participants/P1"
@onready var participant2 = $"Event Control/Participants/P2"
@onready var participant3 = $"Event Control/Participants/P3"
@onready var trophyContainer = $"Event Control/Trophy"
@onready var winner = $"Event Control/Trophy/Winner"
@onready var ticket1 = $Control/Tickets/Sprite2D
@onready var ticket2 = $Control/Tickets/Sprite2D2
@onready var ticket3 = $Control/Tickets/Sprite2D3

var Participants:Array = []

var fortlose = [ 	'%s was gored by a bull!', "The challenge of might claims %s - they're eliminated.",
					"%s's resilience falls short, they're out of the competition.", "Farewell, %s! The fortitude challenge proves too much.", 
					"%s succumbs to the endurance trial, ending their journey.", "Strength fails %s, they're eliminated.", 
					"The grueling endurance test takes %s down.", "Alas, %s's endurance buckles under the pressure.", 
					"The perseverance challenge claims %s - they're eliminated.", "%s's strength wanes - they're out!", 
					"The fortitude trial overwhelms %s, ending their journey.", "Farewell, %s! The test of might proved too tough.", 
					"%s's power wavers, and they exit the competition.", "%s's force weakens, and they bid goodbye."]

var reflose = [ '%s was knocked from their horse AND from the running!', "%s slips on the balance beam - out of the competition!",
					"Farewell, %s! The twisting obstacle course claims another.", "%s's grip falters on the rock-climbing wall - they're out!",
					"Rope bridge foils %s's progress - they're out!", "%s couldn't swing past the pendulum - eliminated.",
					"Rotating platforms spell the end for %s.", "The acrobatic challenge takes %s - farewell!",
					"And with a stumble, %s's dexterity dreams fade.", "%s slips up, out of the competition.",
					"%s's agility falters, ending their journey.", "%s's grasp slips, no more chances.",
					"%s's stumble seals their fate, they're out.", "%s's nimble journey ends here, alas.",
					"%s's grip falters, and their hopes are dashed.", "Rotation thwarts %s's progress, exit stage right."]

var willlose = [ '%s could\'nt map out the labyrinth.', "%s's willpower crumbles, they're out of the competition.", 
					"Farewell, %s! The test of resolve proved too daunting.", "%s's determination wavers, and they exit the stage.", 
					"%s's courage falters, and they bid goodbye.", "%s's spirit weakens, no more chances.", 
					"Resolve eludes %s, and they are sent packing.", "Willpower test proves insurmountable for %s, they're gone.", 
					"Alas, %s's determination falls short, they leave the competition.", "%s's intellect stumbled - they're out of the competition!", 
					"%s's wisdom falters, and they exit the contest.", "The trial outwits %s, ending their journey.", 
					"%s's brilliance dims, and they bid goodbye.", "The mind puzzle claims %s - they're eliminated.", 
					"%s's knowledge falls short, they're gone.", "Logic eludes %s, and they are sent packing.", 
					"Alas, %s's cleverness fell short, they leave the stage."]

var wintext = [ "Behold, the champion of champions - the victor of Feats of Mastery is %s!", "The realm's bravest soul emerges triumphant - %s is the winner of Feats of Mastery!", 
					"Amidst cheers and admiration, %s stands tall as the ultimate victor!", "With courage and skill, %s conquers all, claiming victory in Feats of Mastery!", 
					"A heroic journey, an unforgettable victory - %s emerges as the true master!", "In a world of challenges, %s shines as the undisputed champion of Feats of Mastery!", 
					"Let the realm celebrate - %s has etched their name in the annals of greatness!", "A tale of valor and prowess concludes with %s as the well-deserved winner!", 
					"The cheers resound, the banners wave - %s is the one who proved mastery!", "From the ashes of trials, %s rises as the ultimate champion of Feats of Mastery!", 
					"Behold, the victor of the Feats of Mastery - %s!", "The realm rejoices as %s emerges triumphant!", 
					"With courage and skill, %s claims the title!", "The one who conquered all challenges is %s!", 
					"A new legend is born - the champion, %s!", "The journey's end brings glory to %s!", 
					"In a display of mastery, %s emerges as the winner!", "Let us hail %s, the undisputed champion!", 
					"Through trials and triumphs, %s stands victorious!", "The cheers resound for %s, the ultimate victor!", 
					"Ladies and gentlemen, give a roaring applause to our champion, %s!", "Amidst the cheers, %s emerges as the true master of Feats of Mastery!", 
					"In a display of unmatched skill, %s conquers all challenges to claim victory!", "The realm hails %s as the triumphant hero of this epic competition!", 
					"With unwavering determination, %s stands tall as the Feats of Mastery winner!", "Let it be known throughout the land that %s is the one to beat - the ultimate victor!", 
					"A standing ovation for %s, the embodiment of courage and mastery!", "From the first trial to the last, %s proves their prowess!", 
					"With their name etched in history, %s is crowned the grand champion!", "Cheers fill the air as %s hoists the victor's trophy, a true legend of Feats of Mastery!"]

func setParticipant1(text:String = ""): if text != "": participant1.text = text
func setParticipant2(text:String = ""): if text != "": participant2.text = text
func setParticipant3(text:String = ""): if text != "": participant3.text = text
func setWinner(text:String = ""): if text != "": winner.text = text

func _ready():
	setupInterface()

func setupInterface():
	Participants = []
	ticketControl.global_position = Vector2(760, -300)
	eventControl.global_position = Vector2(760, -300)
	trophyContainer.modulate = Color(1.0, 1.0, 1.0, 0.0)
	participantContainer.modulate = Color(1.0, 1.0, 1.0, 1.0)
	ticket1.modulate = Color8(69, 69, 69)
	ticket2.modulate = Color8(69, 69, 69)
	ticket3.modulate = Color8(69, 69, 69)
	participant1.modulate = Color(1,1,1,1)
	participant2.modulate = Color(1,1,1,1)
	participant3.modulate = Color(1,1,1,1)
	myEventSFX.stream = load("res://_ Assets/sfx/Crit Fail.mp3")

func fadeParticipant(strName:String = ""):
	myEventSFX.play()
	if strName != "":
		if participant1.text == strName: myAnimator.play("Part1 Fall")
		elif participant2.text == strName: myAnimator.play("Part2 Fall")
		elif participant3.text == strName: myAnimator.play("Part3 Fall")
		else:
			print(util.prefix("B") + "FoM failed to remove non-matching participant " + strName)
	
func addParticipant(addchar:Character = null) -> Dictionary:
	if addchar != null:
		if Participants.has(addchar):
			IRCController.send_data("PRIVMSG #nonmajornerd : " + addchar.characterData["name"] + " has already purchased a ticket for the next event!")
			return {}
		else:
			if not myAudio.playing: myAudio.play()
			
			if Participants.size() < 3:
				Participants.append(addchar)
				
				# 3 tickets have been purchased
				if Participants.size() == 3:
					setParticipant3(addchar.characterData["name"])
					
					myAnimator.play("slide")
					await myAnimator.animation_finished
					myAnimator.play("fade 3")
					await get_tree().create_timer(6).timeout
					myAnimator.play_backwards("slide")
												
					myTABrain.getFinalFoMTicket()
					await get_tree().create_timer(2).timeout
					myTABrain.getFoMStart()
					
					await get_tree().create_timer(2).timeout
					return await runEvent()
					
					
				else:
					var _openings = " openings remain!"
					var ticketsRemaining = 3 - Participants.size()

					if ticketsRemaining == 2:						
						setParticipant1(addchar.characterData["name"])
						
						myTABrain.getFirstFoMTicket()
						myAnimator.play("slide")
						await myAnimator.animation_finished
						myAnimator.play("fade 1")
						await get_tree().create_timer(6).timeout
						myAnimator.play_backwards("slide")
						
					elif ticketsRemaining == 1:
						myTABrain.getFoMTicket()
						_openings = " opening remains!"
						setParticipant2(addchar.characterData["name"])
						
						myAnimator.play("slide")
						await myAnimator.animation_finished
						myAnimator.play("fade 2")
						await get_tree().create_timer(6).timeout
						myAnimator.play_backwards("slide")
							
					#IRCController.send_data("PRIVMSG #nonmajornerd : " + addchar.characterData["name"] + " has purchased a ticket to participate in the next Feats of Mastery event! " + str(ticketsRemaining) + openings)
					return {}
					
			else:
				return {} #too many participants
	else:
		return {} #null char ref
		

func runEvent() -> Dictionary:
	
	var att:String = ""
	var attributes:Array = ["fort", "ref", "will"]
	var dc = 10

	var lossText:String = ""
	
	var fomRound:int = 0
	var running:bool = true
	
	var results = {}
	
	myEventAudio.play()
	myAnimator.play("slide event")
	await get_tree().create_timer(4).timeout
	
	while running:
		fomRound += 1
		dc = 8 + (2 * fomRound) #dc starts at 10 for round 1 and increments by 2 every round
		
		#pick an attribute
		att = attributes.pick_random()
		
		#each participant makes a roll against the current DC
		for participant in Participants:
			var passed = participant.SkillCheck(dc, att)
			
			if not passed:
				#increment the fail counter
				participant.characterData["fomFailCount"] += 1
				
				#at 3+ fails..
				if participant.characterData["fomFailCount"] >= 3:
					#fade out and remove participant
					fadeParticipant(participant.characterData["name"])
					Participants.remove_at(Participants.find(participant))
					
					#add them to either p1 or p2
					if results.has("p1"): results["p2"] = participant
					else: results["p1"] = participant
					
					#pick a random loss text to broadcast
					if att == "fort": lossText = fortlose.pick_random()
					elif att == "ref": lossText = reflose.pick_random()
					elif att == "will": lossText = willlose.pick_random()
					
					IRCController.send_data("PRIVMSG #nonmajornerd : (" + att.left(1).capitalize() +") "  + (lossText % participant.characterData["name"]) )
					await get_tree().create_timer(3).timeout
					if Participants.size() > 1: await get_tree().create_timer(5).timeout
					
		if Participants.size() == 1:
			running = false

	#whoever is left is the winner!
	results["winner"] = Participants[0]
	setWinner(str(results["winner"].characterData["name"]))
	myEventSFX.stream = load("res://_ Assets/sfx/Cheer.mp3")
	myEventSFX.play()
	myAnimator.play("Win")
	IRCController.send_data("PRIVMSG #nonmajornerd : " + wintext.pick_random() % Participants[0].characterData["name"])
	await get_tree().create_timer(6).timeout
	myAnimator.play_backwards("slide event")
	await get_tree().create_timer(2).timeout
	setupInterface()
	
	return results

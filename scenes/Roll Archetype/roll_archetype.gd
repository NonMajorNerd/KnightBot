extends Node2D

var DEBUG:bool = true

@onready var labelArch:Label = $Control/Archetype
@onready var charSprite:Sprite2D = $"Control/CharSprite Panel/CharacterSprite"
@onready var starSprite:Sprite2D = $"Control/CharSprite Panel/Stars"
@onready var myTimer:Timer = $Timer
@onready var myAnimator:AnimationPlayer = $AnimationPlayer
@onready var myAudio:AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var IRCController:IRC = get_tree().current_scene.find_child("IRC")

var timerPhase = 0

func setCharSprite(texturePath:String = ""): if texturePath != "": charSprite.texture = load(texturePath)
func setStarSprite(texturePath:String = ""): if texturePath != "": starSprite.texture = load(texturePath)
func setArchLabel(text:String = ""): if text != "": labelArch.text = text

func setup(char:Character=null):
	if char != null:
		if DEBUG: print(util.prefix("B"), "Character rolling for archetype; ", char.characterData["name"])
		var archResults:Array = char.RollArchetype() # [str(archetype), archetype_rating]
		var message:String = char.characterData["owner"] + " has rolled the " + archResults[0] + " archetype! ("
		for i in range(int(archResults[1])):
			message = message + ("★")
		if 3 - int(archResults[1]) > 0:
			for i in range(3 - int(archResults[1])):
				message = message + ("☆")
		message = message + ")"
		IRCController.send_data(str("PRIVMSG #nonmajornerd : " + message))
		
		if char.characterData["archetype"] != "null":
			#existing archetype, assign as temp arch
			if DEBUG: print(util.prefix("B"), "Existing archetype found, rolled archetype assigned as temp for character ", char.characterData["name"])
			char.characterData["tempArch"] = archResults[0]
			char.characterData["tempArchRating"] = int(archResults[1])
		else:
			#no archetype
			if DEBUG: print(util.prefix("B"), "No archetype found, rolled archetype assigned for character ", char.characterData["name"])
			char.characterData["archetype"] = archResults[0]
			char.characterData["archetype_rating"] = int(archResults[1])
				
		var classType: String = char.getClassType(str(archResults[0]))	
		setCharSprite("res://_ Assets/GFX/"+ classType +".png") #todo: use arch TYPE here rather than the result
		setArchLabel(archResults[0])
	
		
		if archResults[1] > 0 and archResults[1] < 4:
			var path:String = "res://_ Assets/GFX/" + str(archResults[1]) + "stars.png"
			setStarSprite(path)
		else:
			starSprite.visible = false

		myAnimator.play("Slide")
		myTimer.start()

func _on_timer_timeout():
	timerPhase += 1
	
	if timerPhase == 1:
		myAudio.play()
		myTimer.wait_time = 7	
		myTimer.start()
	else:
		myAnimator.play_backwards("Slide")
		myTimer.wait_time = 1.5
		await myTimer.timeout
		queue_free()
	

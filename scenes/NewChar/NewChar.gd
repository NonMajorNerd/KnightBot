extends Node2D

var DEBUG:bool = true

@onready var myCharCard:CharacterCard = $CharacterCard
@onready var myAnimator:AnimationPlayer = $AnimationPlayer
@onready var myAudio:AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var myTimer:Timer = $Timer

var myNewChar:Character
var timerPhase:int = 0


func _ready():
	myCharCard.clear()

	myCharCard.setCharacterSprite(load("res://_ Assets/GFX/Peasant.png"))
	myCharCard.spriteCharacter.visible = true
		
	myCharCard.setStars(0)

	myCharCard.showCharacter(myNewChar)
	
	
func roll_stat() -> int:
	var rolls:Array = []
	for i in range(0,4):
		rolls.append(randi_range(1,6))
	rolls.sort()
	return rolls[1] + rolls[2] + rolls[3]


func _on_timer_timeout():
	timerPhase += 1
	if timerPhase == 1:
		myAnimator.play("slide")
		myTimer.wait_time = 2
		myTimer.start()
	elif timerPhase in [2,4,6,8]:
		myAudio.play()
		myTimer.wait_time = 1.3
		myTimer.start()
	elif timerPhase == 3:
		myNewChar.characterData["base_fortitude"] = (roll_stat())
		myCharCard.setFort(str(myNewChar.characterData["base_fortitude"]))
		myTimer.start()
	elif timerPhase == 5:
		myNewChar.characterData["base_reflex"] = (roll_stat())
		myCharCard.setRef(str(myNewChar.characterData["base_reflex"]))
		myTimer.start()
	elif timerPhase == 7:
		myNewChar.characterData["base_willpower"] = (roll_stat())
		myCharCard.setWill(str(myNewChar.characterData["base_willpower"]))
		myTimer.start()
	elif timerPhase == 9:
		myNewChar.characterData["gp"] = 100 + (randi_range(1,6) * 10) +  (randi_range(1,6) * 10) #100 + 2d6*10
		myCharCard.setGold(str(myNewChar.characterData["gp"]))
		myTimer.start()
	elif timerPhase == 10:
		myAudio.stream = load("res://_ Assets/sfx/OhMyGoodness.mp3")
		myAudio.play()
		myTimer.wait_time = 5
		myTimer.start()
	elif timerPhase == 11:
		myAnimator.play_backwards("slide")
		myTimer.wait_time = 1.5
		myTimer.start()
	elif timerPhase == 12:
		myTimer.stop()
		queue_free()

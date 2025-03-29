extends Node2D

var DEBUG:bool = true

@onready var myCharCard:CharacterCard = $CharacterCard
@onready var myAnimator:AnimationPlayer = $AnimationPlayer
@onready var myAudio:AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var myTimer:Timer = $Timer

var timerPhase:int = 0

func _ready():
	myAnimator.stop(false)

func setup(setupChar:Character=null):
	if setupChar != null:
		myCharCard.showCharacter(setupChar)
		myTimer.start()

func _on_timer_timeout():
	timerPhase += 1
	if timerPhase == 1:
		myAnimator.play("slide")
		myTimer.wait_time = 1
		myTimer.start()
	elif timerPhase == 2:
		myAudio.stream = load("res://_ Assets/sfx/OhMyGoodness.mp3")
		myAudio.play()
		myTimer.wait_time = 5
		myTimer.start()
	elif timerPhase == 3:
		myAnimator.play_backwards("slide")
		myTimer.wait_time = 1.5
		myTimer.start()
	elif timerPhase == 4:
		myTimer.stop()
		queue_free()

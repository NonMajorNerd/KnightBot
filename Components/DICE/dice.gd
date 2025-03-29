extends Node2D
class_name Dice

@onready var myAnimationTimer = $Animation
@onready var myRollingTimer = $Rolling
@onready var myLabel = $RichTextLabel
@onready var myAudio = $AudioStreamPlayer2D

@onready var audioCritSuccess = preload("res://_ Assets/sfx/Crit Success.mp3")
@onready var audioCritFail = preload("res://_ Assets/sfx/Crit Fail.mp3")

@export var fix = 0

@onready var myFaceCount = 6
@onready var myPostfix = ""

func setup(faceCount:int = 6):
	if faceCount not in [4, 6, 8, 10, 12, 20]:
		print('Dice seutp called with bad face count.')
		return
	myFaceCount = faceCount
	myLabel.text = str(myFaceCount)
	if faceCount in [4, 8, 10, 12, 20]:
		myPostfix = "_ON_D" + str(myFaceCount)
		myLabel.text += myPostfix
	
func _roll():
	myRollingTimer.start()
	myAnimationTimer.start()
	myAudio.play()

func _on_rolling_timeout():
	myAnimationTimer.stop()
	myLabel.text = str(randi_range(1,myFaceCount)) + myPostfix
	if fix > 0 : myLabel.text = str(fix) + myPostfix
	var diceVal = int(myLabel.text.split("_")[0])
	if diceVal == 1:
		myAudio.stream = audioCritFail
		myAudio.play()
	if diceVal == myFaceCount:
		myAudio.stream = audioCritSuccess
		myAudio.play()
	
func _on_animation_timeout():
	myLabel.text = str(randi_range(1,myFaceCount)) + myPostfix

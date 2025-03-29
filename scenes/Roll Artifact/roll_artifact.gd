extends Node2D

@onready var yesPanel = $Control/YesPanel
@onready var artName = $Control/YesPanel/Name
@onready var artDesc = $Control/YesPanel/Description
@onready var noPanel = $"Control/NoPanel"
@onready var artSprite = $"Control/YesPanel/ArtifactSprite Panel/ArtifactSprite"
@onready var myController = get_tree().current_scene
@onready var artifactPool = myController.artifactPool
@onready var myAnimator = $AnimationPlayer
@onready var myAudio = $AudioStreamPlayer2D
@onready var myAudio2 = $AudioStreamPlayer2D2
@onready var myTimer = $Timer

var timerPhase = 0

var results = {"found": false, "xp": 15}

func setName(strName=null): if strName != null: artName.text = str(strName).strip_edges()
func setDesc(strDesc=null): if strDesc != null: artDesc.text = str(strDesc).strip_edges()
func setSprite(texture:Texture2D = null): if texture != null: artSprite.texture = texture


func _ready():
	myTimer.start()


func rollForArtifact(artChar:Character=null) -> Dictionary: # return {found: true, xp: 10}
	#pay the man!
	artChar.characterData["gp"] -= 45
	
	var baseChance:int = 40
	var will:int = artChar.getWill()
	
	var modifier:int = 0
	if will % 2 == 0: #even number
		modifier = int((will - 10)/2)
	else: #odd number
		modifier = int((will - 11)/2)
							
	if will < 10: modifier = 0
	
	modifier = modifier * 10
	
	var finalChance = baseChance + modifier
	var d100 = randi_range(1, 100)
	
	if finalChance >= d100:
		#locating an artifact awards 20 xp in addition to the 20 rewarded for searching.
		results["found"] = true
		results["xp"] += 20

		var foundArtifact:Artifact = artifactPool.pick_random()
		showArtifact(foundArtifact["data"])
		# TODO :: Need to check that there are existing artifacts in the pool which aren't the same
		# as the characters current artifact, otherwise this will be an infinite loop
		
		#if we already have an artifact
		if artChar.characterData["artifact"].size() > 0:			
			#assign the found artifact to tempartifact
			artChar.characterData["tempArtifact"] = foundArtifact["data"]		
		else:
			#no existing artifact, assign foundArtifact to 
			artChar.characterData["artifact"] = foundArtifact["data"]
			
	else:
		showArtifact()
	
	return results


func showArtifact(artifact={}):
	if artifact.size() == 0: #not found
		yesPanel.visible = false
		noPanel.visible = true
	
	else: #found
		yesPanel.visible = true
		noPanel.visible = false
		setName(artifact["artName"])
		setDesc("   " + artifact["artDesc"])
		setSprite(load("res://_ Assets/GFX/_ Artifacts/GFX/"+ artifact["artImg"] + ".png"))


func _on_timer_timeout():
	if timerPhase == 0:
		myAudio2.stream = load("res://_ Assets/sfx/Unlock and Open.mp3")
		myAudio2.play()
		myTimer.wait_time = 1
		myTimer.start()
		
	elif timerPhase == 1:
		myAnimator.play("slide")
		myTimer.wait_time = 1
		myTimer.start()
		
	elif timerPhase == 2:
		if results["found"] == true:
			myAudio2.stream = load("res://_ Assets/sfx/ArtifactYes.mp3")
		else:
			myAudio2.stream = load("res://_ Assets/sfx/ArtifactNo.mp3")
			
		myAudio2.play()
		myTimer.wait_time = 7
		myTimer.start()
		
	elif timerPhase == 3:
		myAnimator.play_backwards("slide")
		myTimer.wait_time = 1
		myTimer.start()
		
	else:
		queue_free()
		
	timerPhase += 1

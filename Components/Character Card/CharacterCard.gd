extends Control
class_name CharacterCard

var DEBUG:bool = true

@onready var labelName:Label = $"Control/Character Name"
@onready var labelTitle:Label = $"Control/Character Title"
@onready var labelLevel:Label = $"Control/Character Level"
@onready var labelGold:Label = $"Gold/Character Gold"
@onready var labelFort:Label = $Stats/Fort
@onready var labelRef:Label = $Stats/Reflex
@onready var labelWill:Label = $Stats/Will

@onready var spriteCharacter:Sprite2D = $"CharSprite Panel/CharacterSprite"
@onready var spriteArtifact:Sprite2D = $"ArtifactSprite Panel/ArtifactSprite"
@onready var spriteStars:Sprite2D = $"CharSprite Panel/Stars"

func setName(strname:String ="null"): if strname != "null": labelName.text = strname
func setTitle(title:String ="null"): if title != "null": labelTitle.text = title
func setLevel(level:String ="null"): if level != "null": labelLevel.text = level
func setGold(gold:String ="null"): if gold != "null": labelGold.text = gold
func setFort(fort:String ="null"): if fort != "null": labelFort.text = fort
func setRef(ref:String ="null"): if ref != "null": labelRef.text = ref
func setWill(will:String ="null"): if will != "null": labelWill.text = will

func setCharacterSprite(texture:Texture2D = null): if texture != null: spriteCharacter.texture = texture
func setArtifactSprite(texture:Texture2D = null): if texture != null: spriteArtifact.texture = texture
func setStarsSprite(texture:Texture2D = null): if texture != null: spriteStars.texture = texture

func clear():
	setName("")
	setTitle("")
	setLevel("")
	setGold("")
	setFort("")
	setRef("")
	setWill("")
	setCharacterSprite(load("res://_ Assets/GFX/Peasant.png"))
	
func setStars(rating:int=0):
	if rating == 0: 
		spriteStars.visible = false
	else:
		var file:String = str(clampi(rating, 0, 3)) + "stars.png"
		setStarsSprite(load("res://_ Assets/GFX/" + str(file)))

func showCharacter(mychar:Character=null):

	if mychar != null:
		clear()
		setName(str(mychar.characterData["name"]))
		setLevel("Level " + str(mychar.characterData["level"]))
		var archetype = "The Peasant"
		setStars(mychar.characterData["archetype_rating"])
		if mychar.characterData["archetype"] != "null":
			archetype = str(mychar.characterData["archetype"])
			setCharacterSprite(load("res://_ Assets/GFX/"+ mychar.getClassType() +".png"))
			setTitle(archetype)
		if not mychar.characterData["artifact"].is_empty():
			setArtifactSprite(load("res://_ Assets/GFX/_ Artifacts/GFX/"+ mychar.characterData["artifact"]["artImg"] + ".png"))
			spriteArtifact.scale = Vector2(0.12, 0.12)
		setFort(str(mychar.getFortitude()))
		setRef(str(mychar.getReflex()))
		setWill(str(mychar.getWill()))
		setGold(str(mychar.characterData["gp"]))
	else:
		if DEBUG: print(util.prefix("B"), "Null character on showCharacter()")

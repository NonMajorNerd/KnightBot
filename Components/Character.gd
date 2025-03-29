extends Node2D
class_name Character

var DEBUG: bool = true

var characterData: Dictionary = {
	"owner": "null", #twitch username
	"name": "null", #character name

	"level": 1,
	"xp": 0,
	"gp": 0,

	"base_fortitude": 0,
	"base_reflex": 0,
	"base_willpower": 0,

	"archetype": "null",
	"archetype_rating": 0,

	"tempArch": "null",  #used to store the last archetype rolled
	"tempArchRating": 0,

	"dungeonLevel": 0,

	"artifact": {}, 
	"tempArtifact": {}, #used to store the last artifact pulled
	
	"fomFailCount": 0
	
	}
	
func _init(initowner:String = "null", initname:String = "null"):
		
	characterData["owner"] = initowner #twitch username
	characterData["name"] = initname #character name
	
	if DEBUG and initowner in ["null", "NoOwner"]: print("Character created with null or missing owner.")
	if initname in ["null", "NoName"]:
		if DEBUG: print("Character created with null or missing name.")
		characterData["name"] = ["Dillip", "Dorkus Maximus", "Chrenry", "B'Ob"].pick_random()

func getFortitude() -> int:
	var result:int = characterData["base_fortitude"]
	if not characterData["artifact"].is_empty(): result += characterData["artifact"]["fort_mod"]
	result += getArchBonus(characterData["archetype"],"fort")
	if result > 20: result = 20
	return result
	
func getReflex() -> int:
	var result:int = characterData["base_reflex"]
	if not characterData["artifact"].is_empty(): result += characterData["artifact"]["ref_mod"]
	result += getArchBonus(characterData["archetype"],"ref")
	if result > 20: result = 20
	return result
	
func getWill() -> int:
	var result:int = characterData["base_willpower"]
	if not characterData["artifact"].is_empty(): result += characterData["artifact"]["will_mod"]
	result += getArchBonus(characterData["archetype"],"will")
	if result > 20: result = 20
	return result
	
func getDescription() -> String:
	var result:String = ""
	
	result += characterData["name"]
	if characterData["archetype"] != "null":
		result += " The " + characterData["archetype"] + " ("
		if characterData["archetype_rating"] == 1: result += "★☆☆"
		elif characterData["archetype_rating"] == 2: result += "★★☆"
		else: result += "★★★"
		result += ")"
		
	if characterData["artifact"].size() > 0:
		result += "; They carry an artifact " + characterData["artifact"]["artName"] + "."

	result += " || Fort " + str(getFortitude()) + ", "
	result += "Ref " + str(getReflex()) + ", "
	result += "Will " + str(getWill())
	result += " ||	Level " + str(characterData["level"]) + ", " + str(characterData["xp"]) + " xp"
	result += " || " + str(characterData["gp"]) + "gp"
	
	return result

func getClassType(archetype:String = "") -> String:
	if archetype == "": archetype = characterData["archetype"]
	var classtype:String = "Peasant"
	
	# 55% C, 35% UC, 10% R
	if archetype == "Fighter" or archetype == "Vanguard" or archetype == "Champion": classtype = 'Fighter'
	elif archetype == "Magi" or archetype == "Conjurer" or archetype == "Sage": classtype = 'Magi'
	elif archetype == "Thief" or archetype == "Rogue" or archetype == "Assassin": classtype = 'Thief'
	elif archetype == "Acolyte" or archetype == "Healer" or archetype == "Cleric": classtype = 'Acolyte'
	elif archetype == "Archer" or archetype == "Ranger" or archetype == "Warden": classtype = 'Archer'
	else: if DEBUG: print(util.prefix("B"), '!! GetClassType unhandled classtype of', classtype)
		
	return str(classtype)

func CheckLevel() -> bool:
		
		if DEBUG: print("")
		if DEBUG: print("CheckLevel")
		
		var level = characterData["level"]
		var xp = characterData["xp"]
		var XPNeed = round(50+(5*level)*(5*level))
		if DEBUG: print ("	   have", xp, "at level", level, ".. need", XPNeed)
		
		var leveled = false
		if xp >= XPNeed:
			characterData["level"] += 1
			xp -= XPNeed
			leveled = true
		
			#every 5 levels add +1 to the base of one stat
			if level % 5 == 0:
				var opts = ['f', 'r', 'w']
				var stat = opts.pick_random()
				
				if stat == 'f': characterData["base_fortitude"] += 1
				elif stat == 'r': characterData["base_reflex"] += 1
				elif stat == 'w': characterData["base_willpower"] += 1
				
				if characterData["base_fortitude"] > 18: characterData["base_fortitude"] = 18
				if characterData["base_reflex"] > 18: characterData["base_reflex"] = 18
				if characterData["base_willpower"] > 18: characterData["base_willpower"] = 18
				
				if DEBUG: print(characterData["name"], " gained one ", stat)
				
		if leveled:	
			#re-calculate new XP need
			XPNeed = round(12.55+(2*level)*level)
			
			if DEBUG: print ("	   ..now have", xp, "at level", level, ".. need", XPNeed)
			if xp >= XPNeed:
				characterData["level"] += 1
				xp -= XPNeed
				if DEBUG: print ("     .. going back to the start")
				CheckLevel()
				
		return leveled
	
func getModifier(attribute:String) -> int:
	#returns the modifier for a given attribute
	# (attribute - 10) / 2
	var att = 0
	
	if attribute == "fort": att = getFortitude()
	elif attribute == "ref": att = getReflex()
	elif attribute == "will": att = getWill()
	
	if att % 2 != 0: att = att - 1
	return int((att - 10) / 2)

func SkillCheck(dc:int, attribute:String) -> bool:
	#roll against a dc and return pass/fail (t/f)
	
	var roll:int = randi_range(1, 20)

	roll += getModifier(attribute)
	
	return (roll >= dc)
	

	
func getArchBonus(archetype, bonus):

	if archetype == "null": archetype = "Peasant"

	var data = {"Peasant": {"fort":0, "ref":0, "will":0},
				"Acolyte": {"fort":0, "ref":0, "will":1},	"Archer": {"fort":0, "ref":1, "will":0},
				"Healer": {"fort":0, "ref":0, "will":2},	"Ranger": {"fort":0, "ref":2, "will":0},
				"Cleric": {"fort":1, "ref":0, "will":2},	"Warden": {"fort":0, "ref":3, "will":0},
				
				"Fighter": {"fort":2, "ref":-1, "will":0},	"Magi": {"fort":-1, "ref":0, "will":2},
				"Vanguard": {"fort":2, "ref":0, "will":0},	"Conjurer": {"fort":0, "ref":0, "will":2},
				"Champion": {"fort":3, "ref":0, "will":0},	"Sage": {"fort":0, "ref":1, "will":2},
				
				"Thief": {"fort":-1, "ref":2, "will":0},
				"Rogue": {"fort":0, "ref":2, "will":0},
				"Assassin": {"fort":0, "ref":3, "will":0}
				}

	return data[archetype][bonus]

func RollArchetype() -> Array:
	var d100:int = randi_range(1, 100)
	var archetype:String = "Peasant"
	var archetype_rating:int = 0
	
	# 55% C, 35% UC, 10% R
	if d100 <= 11: archetype =		"Fighter" 
	elif d100 <= 22: archetype =	"Magi"
	elif d100 <= 33: archetype =	"Thief"
	elif d100 <= 44: archetype =	"Acolyte"
	elif d100 <= 55: archetype =	"Archer"
	
	elif d100 <= 62: archetype =	"Vanguard"
	elif d100 <= 69: archetype =	"Conjurer"
	elif d100 <= 76: archetype =	"Rogue"
	elif d100 <= 83: archetype =	"Healer"
	elif d100 <= 90: archetype =	"Ranger"

	elif d100 <= 92: archetype =	"Champion"
	elif d100 <= 94: archetype =	"Sage"
	elif d100 <= 96: archetype =	"Assassin"
	elif d100 <= 98: archetype =	"Cleric"
	elif d100 <= 100: archetype =	"Warden"
	
	if d100 <= 55: archetype_rating = 1
	elif d100 <= 90: archetype_rating = 2
	else: archetype_rating = 3	

	return [str(archetype), archetype_rating]

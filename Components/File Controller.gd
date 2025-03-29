extends Node2D
class_name FileController

#	- "Master Users" is loaded when the bot starts and represents the starting point for the stream
#	- "Active Users" is added to on Join events and represents the currently-active users
#		- TODO :: on Part events, users have to be moved from Active back to Master

#	Saving
#		- Both user lists are saved as unique, time-stamped files
#		- For every user in Active Users, we check for matching owners in the Master Users list
#			- If a matching owner is found..
#				- The entry in Master Users is removed
#				- The entry in Active Users is added to Master Users
#		- The updated Master Users list is saved over the primary "CharacterData.dat" file

var DEBUG:bool = true

var activeUsers:Array = []
var masterUsers:Array = []

#used to customsort the MasterUsers file
func charsort(a, b):
	if a.characterData["name"].to_upper() < b.characterData["name"].to_upper():
		return true
	return false
	
#this function gets passed a login (eg "nonmajornerd") and a list (master or active users) and searches for a character
#if no character match is found, it returns null.
func getCharacterFromOwner(charOwner:String="", list:Array=[]) -> Character:
	var result:Character = null
	if charOwner.length() > 0 and list.size() > 0:
		for listChar in list:
			if listChar.characterData["owner"] == charOwner:
				result = listChar
				break
					
	return result

func updateMaster():
	var updatedMasterUser:Array = []
	var exists:bool = false
	var found:bool = false
	
	# for each known character
	for masterChar in masterUsers:
		
		#make sure we dont already exist in the updated list
		exists = false
		for newUsers in updatedMasterUser:
			if newUsers.characterData['owner'] == masterChar.characterData['owner']:
				exists = true
				break
		
		if not exists:
			# look for a 'possibly updated' active user
			found = false
			for activeChar in activeUsers:
				if activeChar.characterData['owner'] == masterChar.characterData['owner']:
					# if we find one, add that to the updated list
					found = true
					updatedMasterUser.append(activeChar)
			
			# if not found in activeUsers, use the record in masterUsers
			if found == false: updatedMasterUser.append(masterChar)

	masterUsers.clear()
	masterUsers = updatedMasterUser.duplicate(true)
	

func listToRecords(list:Array, file:FileAccess=null):
	for listUser in list:		
		file.store_var(listUser.characterData)

func listToCSV(list:Array, file:FileAccess=null):
	
	# which keys in characterData we want saved to the CSV
	var savedKeys:PackedStringArray = ["name", "level", "xp", "gp", "fortitude", "reflex", "willpower", "archetype", "artifact"]
	
	# How we want the headers to appear on the html table
	var headers:PackedStringArray = ["Name", "Level", "XP", "Gold", "Fortitude", "Reflex", "Willpower", "Archetype", "Artifact"]
	file.store_csv_line(headers)
	
	# build rows for each character
	for listUser in list:
		var userRec:PackedStringArray = []		
		for key in listUser.characterData:
			
			if key == "name":
				userRec.append(listUser.characterData["name"] + "/" + listUser.characterData["owner"])
			
			# parse stat keys
			elif key == "base_fortitude": userRec.append(str(listUser.getFortitude()))
			elif key == "base_reflex": userRec.append(str(listUser.getReflex()))
			elif key == "base_willpower": userRec.append(str(listUser.getWill()))
			
			# parse Archetype key
			elif key == "archetype":
				
				var archResult:String = ''
				
				if listUser.characterData["archetype"] == 'null': archResult = 'Peasant/Peasant'
				else:
					
					archResult = listUser.getClassType() + "/"
					
					archResult += listUser.characterData["archetype"] + ' ('
					if listUser.characterData["archetype_rating"] == 1: archResult += '★☆☆'
					elif listUser.characterData["archetype_rating"] == 2: archResult += '★★☆'
					else: archResult += '★★★'
					archResult += ')'
				
				userRec.append(archResult)
			
			# parse Artifact key
			elif key == "artifact":
				var artResult:String = ''
				
				if listUser.characterData["artifact"].size() > 0:
					artResult = listUser.characterData["artifact"]["artImg"] + "/"
					artResult += listUser.characterData["artifact"]["artName"]
				else:
					artResult = 'None/None'
					
				userRec.append(artResult)
				
				# all other keys transposed as they are
			else:
				if key in savedKeys:
					userRec.append(str(listUser.characterData[key]))
					
		# store final record
		file.store_csv_line(userRec)
	
func recordToList(record, list:Array):
	var newChar: Character = Character.new("RecordToMaster", "RecordToMaster") #providing a fake owner and name prevents the debug message warning about owner-less characters
	if DEBUG: print(util.prefix("B"), "Loading character data;")
	for key in record:
		if key not in ["tempArch", "tempArchRating"]:
			if DEBUG: print(util.prefix("B"), "   ", str(key), ": ", str(record[key]) )
			newChar.characterData[key] = record[key]
	list.append(newChar)

func SaveToCSV(path:String="null"):
	
	if path == "null":
		if DEBUG: print(util.prefix("B"), "!! [CRITICAL] !! No path provided to save master CSV File. ")
		return		
		
	if DEBUG: print(util.prefix("B"), "Saving master CSV File at ", path)
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	#save Master Users CSV file
	if  DEBUG: print(util.prefix("B"), "Saving master user CSV file [", path, "]")
	file = FileAccess.open(path, FileAccess.WRITE)
	
	listToCSV(masterUsers,file)
	
	file.close()

func SaveToJSON(path:String="null"):
	if path == "null":
		if DEBUG: print(util.prefix("B"), "!! [CRITICAL] !! No path provided to save master File. ")
		return		

	#backup existing Active Users file
	var backupPath = path.left(path.length()-4) + str(Time.get_datetime_string_from_system()).replace("-","").replace(":","") + "ACTIVE_BK.dat"
	if  DEBUG: print(util.prefix("B"), "Backing up active user file [", backupPath, "]")
	var file = FileAccess.open(backupPath, FileAccess.WRITE)
	listToRecords(activeUsers,file)
	file.close()

	#backup existing Master Users file
	backupPath = path.left(path.length()-4) + str(Time.get_datetime_string_from_system()).replace("-","").replace(":","") + "MASTER_BK.dat"
	if  DEBUG: print(util.prefix("B"), "Backing up master user file [", backupPath, "]")
	file = FileAccess.open(backupPath, FileAccess.WRITE)
	listToRecords(masterUsers,file)
	file.close()
	
	#update Master Users list
	updateMaster()

	#save updated Master Users file
	if  DEBUG: print(util.prefix("B"), "Saving updated master user file [", path, "]")
	file = FileAccess.open(path, FileAccess.WRITE)
	listToRecords(masterUsers,file)
	file.close()
		
	masterUsers.sort_custom(charsort)
	var csvPath:String = path.left(path.length()-3) + "csv" #convert "path.dat" to "path.csv"
	SaveToCSV(csvPath)

func LoadFromJSON(path:String="null"):
	if path == "null":
		if DEBUG: print(util.prefix("B"), "!! [CRITICAL] !! No path provided to load master FILE. ")
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	masterUsers.clear()
	if file:
		while file.get_position() < file.get_length(): #the apparently more accurate way to do EoF checks in godot? I guess?
			recordToList(file.get_var(), masterUsers)
		file.close()
			
	if DEBUG:
		print (util.prefix("B"), "Loaded the following MasterUser from memory")
		for masterChar in masterUsers:
			print(util.prefix("B"), "   ", masterChar.characterData["name"], " (", masterChar.characterData["owner"], ")")

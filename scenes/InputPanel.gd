extends Control

@onready var myInputLabel:RichTextLabel = $Panel/RichTextLabel_Input
@onready var myYawBall:Panel = $Panel/YawPanel/YawBall 
@onready var myPitchRollBall:Panel = $"Panel/PitchRoll Panel/PitchRollBall"

@onready var my7Button:Panel = $"Panel/7 Panel"

# entries in PanelInputMap are "[DEVICE]/[TYPE]/[INDEX]":Value
# TYPE is either "A" for Axis (JoypadMotion) or "B" for Button (JoypadButton)
# value typically used for T/F (1.0/0.0), but can also return float axis values
#		Device1 is Tartarus. Button indexes are -1 value printed on the key
#		Device 2 is VKB. Axis 0 is L/R, axis 1 is F/B
#		Device 3 is Pedals. Axis 0 and 1 are right and left toe break, axis 2 is yaw movement.
var PanelInputMap:Dictionary = {"1/B/5":0.0,		# Tartarus 6 (Bst)
								"1/B/6":0.0,		# Tartarus 7 (Up)
								"1/B/7":0.0,		# Tartarus 8 (Fw)
								"1/B/8":0.0,		# Tartarus 9 (Dn)
								"1/B/11":0.0,		# Tartarus 12 (Lf)
								"1/B/12":0.0,		# Tartarus 13 (Bk)
								"1/B/13":0.0,		# Tartarus 14 (Rt)
									
								"2/A/0":0.0,		# VKB L/R
								"2/A/1":0.0,		# VKB F/B
								
								"3/A/2":0.0			# Pedals Yaw
								}

func findInputInfo(inputKey:String = "", outIndex:int = 0) -> String:
	return inputKey.split("/")[outIndex]

# parse the event and update the relevant value in 'PanelInputMap'
func _unhandled_input(event):
	for kvp in PanelInputMap:
		if findInputInfo(kvp,1) == "B":
			if event is InputEventJoypadButton:
				if int(event.button_index) == int(findInputInfo(kvp, 2)):
					if event.pressed:
						PanelInputMap[kvp] = 1.0
					else:
						PanelInputMap[kvp] = 0.0
		else:
			if event is InputEventJoypadMotion:
				if int(event.axis) == int(findInputInfo(kvp,2)):
					PanelInputMap[kvp] = event.axis_value
	
func _process(delta):
	myInputLabel.text = ""
	for kvp in PanelInputMap:
		myInputLabel.text += kvp + "; " + str(PanelInputMap[kvp]) + "\n"
	
	if PanelInputMap["2/A/0"] == 0.0 and PanelInputMap["2/A/1"] == 0.0 :
		myPitchRollBall.modulate.a = 0.5
	else:
		if PanelInputMap["2/A/0"] != 0.0:
			myPitchRollBall.modulate.a = 1
			myPitchRollBall.position.x = ((myPitchRollBall.get_parent().size.x/2) - myPitchRollBall.size.x/2) + (((myPitchRollBall.get_parent().size.x/2) - myPitchRollBall.size.x/2) * PanelInputMap["2/A/0"])
		if PanelInputMap["2/A/1"] != 0.0:
			myPitchRollBall.modulate.a = 1
			myPitchRollBall.position.y = ((myPitchRollBall.get_parent().size.y/2) - myPitchRollBall.size.y/2) + (((myPitchRollBall.get_parent().size.y/2) - myPitchRollBall.size.y/2) * PanelInputMap["2/A/1"])
			
	if PanelInputMap["3/A/2"] != 0.0:
		myYawBall.modulate.a = 1
		myYawBall.position.x = ((myYawBall.get_parent().size.x/2) - myYawBall.size.x/2) - (((myYawBall.get_parent().size.x/2) - myYawBall.size.x/2) * PanelInputMap["3/A/2"])
	else:
		myYawBall.modulate.a = 0.5
		
	

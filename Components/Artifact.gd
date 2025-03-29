extends Node2D
class_name Artifact

var DEBUG:bool = true

var data:Dictionary = {
	"artName" : "NoName",
	"artDesc" : "NoDesc",
	"artImg" : null,

	"spawn_chance" : 0,

	"fort_mod" : 0,
	"ref_mod" : 0,
	"will_mod" : 0
	}

func _init(aname:String="", desc:String="", img:String="", spawn_chance:int=0, fort_mod:int=0, ref_mod:int=0, will_mod:int=1):
	data["artName"] = aname
	data["artDesc"] = desc
	data["artImg"] = img
	data["spawn_chance"] = spawn_chance
	data["fort_mod"] = fort_mod
	data["ref_mod"] = ref_mod
	data["will_mod"] = will_mod

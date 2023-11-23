extends Node

var content: Dictionary

func _ready():
	var file = FileAccess.open("res://autoload/item_data.json", FileAccess.READ)
	
	content = JSON.parse_string(file.get_as_text())
	
	file.close()


func get_texture_name(ID = "0"):
	return content[ID]["Image"]
	
func get_item_name(ID = "0"):
	return content[ID]["Name"]

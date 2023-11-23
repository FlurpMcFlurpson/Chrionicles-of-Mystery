extends Sprite2D

func _ready():
	set_property()

func set_property(ID = "0"):
	var texture =load("res://art//items/"+ ItemData.get_texture_name(ID))

extends Control

var is_open = false

func _ready():
	close()
func  _process(delta):
	if Input.is_action_just_pressed("Open_menu"):
		if is_open:
			close()
		else:
			open()

func close():
	visible = false
	is_open = false
func open():
	visible = true
	is_open = true




func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

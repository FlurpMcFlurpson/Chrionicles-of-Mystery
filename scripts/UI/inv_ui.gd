extends Control

@onready var Vitality = $TabContainer/Stats/PanelContainer/VBoxContainer/Vitality
@onready var agility = $TabContainer/Stats/PanelContainer/VBoxContainer/agility
@onready var strength = $TabContainer/Stats/PanelContainer/VBoxContainer/strength
@onready var luck = $TabContainer/Stats/PanelContainer/VBoxContainer/luck
@onready var defense = $TabContainer/Stats/PanelContainer/VBoxContainer/defense

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

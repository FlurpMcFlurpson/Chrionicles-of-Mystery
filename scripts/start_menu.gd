extends Control
signal world_changed(world_name)
@export var world_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimationPlayer.play("player_runing")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_setting_button_pressed():
	pass # Replace with function body.


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/scene_manger.tscn")
	global.game_init_load = true

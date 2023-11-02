extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if global.game_init_load == true:
		$player.position = global.player_init_pos
	else:
		$player.position = global.player_exits_coast


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()


func _on_coast_portal_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func _on_coast_portal_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false


func change_scene():
	if global.transition_scene == true and global.current_scene == "world":
		get_tree().change_scene_to_file("res://scenes/coast.tscn")
		global.game_init_load = false
		global.scene_changed()
		
	


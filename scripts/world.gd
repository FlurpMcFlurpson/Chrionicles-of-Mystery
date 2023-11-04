extends Node2D

signal world_changed(world_name)
@export var world_name = "world"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	if global.game_init_load == true:
		$player.position = global.player_init_pos
	else:
		$player.position = global.player_exits_coast


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.transition_scene == true:
		emit_signal("world_changed", world_name)
		global.transition_scene = false


func _on_coast_portal_body_entered(body):
	if body.has_method("player"):
		global.scene_entered = "coast"
		global.transition_scene = true
func _on_coast_portal_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
func _on_world_portal_body_entered(body):
	if body.has_method("player"):
		global.scene_entered = "world"
		global.transition_scene = true
func _on_world_portal_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false


func _on_forest_protal_body_entered(body):
	if body.has_method("player"):
		global.scene_entered = "forest"
		global.transition_scene = false
func _on_forest_protal_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

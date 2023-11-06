extends Node2D
signal world_changed(world_name)
@export var world_name = "world"
var player_last_posx=0
var player_last_posy=0


# Called when the node enters the scene tree for the first time.
func _ready():
	if global.game_init_load == true:
		print("testing")
		$player.position = global.player_init_pos
		global.game_init_load = false
	else:
		print(global.scene_entered)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.transition_scene == true:
		emit_signal("world_changed", world_name)
		global.transition_scene = false
	PlayerState.player_curent_posx = $player.position.x
	PlayerState.player_curent_posy = $player.position.y
	
	
func _on_coast_portal_body_entered(body):
	if body.has_method("player"):
		global.scene_entered = "coast"
		global.transition_scene = true
		player_last_posy = $player.position.y +20
		player_last_posx = $player.position.x +20
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
		


	
	

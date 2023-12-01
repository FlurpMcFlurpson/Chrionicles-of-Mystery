extends Node2D
signal world_changed(world_name)
@export var world_name = ""
var player_last_posx=0
var player_last_posy=0
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerState.is_in_combat = false
	global.transition_scene = false
	handle_player_spwaning_pos(world_name)
	if global.game_init_load == true:
		$player.position = global.player_init_pos
		global.game_init_load = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.transition_scene == true:
		emit_signal("world_changed", world_name)
		global.transition_scene = false
	PlayerState.player_curent_posx = $player.position.x
	PlayerState.player_curent_posy = $player.position.y
	if PlayerState.moveable == false:
		PlayerState.moveable = true
	#print(global.last_scene_used)
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
func handle_player_spwaning_pos(world_name):
	match world_name:
		"coast":
			$player.position = global.player_coast_pos
		"world":
			if global.game_init_load == false:
				$player.position = global.player_exits_coast
			if global.just_in_combat == true:
				$player.position = Vector2(PlayerState.player_curent_posx,PlayerState.player_curent_posy)
 

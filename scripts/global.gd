extends Node

var player_attacking = false

var current_scene = "world"
var transition_scene = false

var player_exits_coast = Vector2(270,380)
var player_init_pos = Vector2(29, 100)

var game_init_load = true


func scene_changed():
	transition_scene = false
	if current_scene =="world":
		current_scene = "coast"
	else:
		current_scene = "world"
	
	

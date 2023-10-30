extends Node

var player_attacking = false

var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_posx = 0
var player_exit_cliffside_posy = 0
var player_start_posx = 0
var player_start_posy = 0

func scene_changed():
	transition_scene = false
	if current_scene =="world":
		current_scene = "coast"
	else:
		current_scene = "world"
	
	

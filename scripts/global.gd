extends Node

var player_attacking = false

var current_scene = ""
var last_scene_used =  ""
var transition_scene = false
var scene_entered = ""
var player_exits_coast = Vector2(270,380)
var player_init_pos = Vector2(100, 100)
var player_coast_pos = Vector2(186, 8)
var game_init_load = false
var current_world_name = ""
var just_in_combat = false
signal item_drop




extends Node

var player_attacking = false
var enemy_spawn_area_posx:float
var enemy_spawn_area_posy:float
var current_scene = ""
var last_scene_used =  ""
var transition_scene = false
var scene_entered = ""
var player_exits_coast = Vector2(270,380)
var player_init_pos = Vector2(548, 407)
var player_coast_pos = Vector2(186, 8)
var player_exits_forest = Vector2(29,89)
var game_init_load = false
var current_world_name = ""
var just_in_combat = false
var enemy_res : Base_Enemy
var damage_delt
var left_coast = true


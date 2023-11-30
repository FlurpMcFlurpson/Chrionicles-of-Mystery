extends Node2D

var enemy_load = preload("res://scenes/enemy/enemy.tscn")

func _ready():
	PlayerState.moveable = false
	enemy_spawn()
	
	
func  enemy_spawn():
	var new_enemy = enemy_load.instantiate()
	new_enemy.position.x = 767
	new_enemy.position.y = 379
	new_enemy.scale.x = 6
	new_enemy.scale.y = 6
	new_enemy.enemy_type = global.enemy_res
	add_child(new_enemy)

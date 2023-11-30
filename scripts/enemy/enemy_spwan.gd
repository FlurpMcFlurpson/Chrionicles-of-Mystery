extends Node2D
var enemy_load = load("res://scenes/enemy/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_spawn()


func  enemy_spawn():
	for i in range(1,2):
		var new_enemy = enemy_load.instantiate()
		new_enemy.position.x = 270#PlayerState.player_curent_posx + randf_range(50,100)
		new_enemy.position.y = 64#PlayerState.player_curent_posy + randf_range(50,100)
		new_enemy.enemy_type = load("res://enemyRes/Slime.tres")
		add_child(new_enemy)

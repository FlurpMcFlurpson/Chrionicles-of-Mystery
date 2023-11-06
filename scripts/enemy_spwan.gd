extends Node2D
var enemy_load = load("res://scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_spawn()


func  enemy_spawn():
	for i in range(3,7):
		var enemy = enemy_load.instantiate()
		enemy.position.x = PlayerState.player_curent_posx + randf_range(50,300)
		enemy.position.y = PlayerState.player_curent_posy + randf_range(50,300)
		add_child(enemy)

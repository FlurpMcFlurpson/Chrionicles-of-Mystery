extends Node2D
var slime_load = load("res://scenes/enemy/enemy.tscn")
var skeleton_load = load("res://scenes/enemy/skeleton.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_spawn()


func  enemy_spawn():
	for i in range(3,7):
		var enemy = slime_load.instantiate()
		enemy.position.x = PlayerState.player_curent_posx + randf_range(50,100)
		enemy.position.y = PlayerState.player_curent_posy + randf_range(50,100)
		add_child(enemy)

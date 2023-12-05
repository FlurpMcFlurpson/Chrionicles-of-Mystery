extends Node2D
var enemy_load = load("res://scenes/enemy/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_spawn()


func  enemy_spawn():
	for i in randi_range(2,4):
		var new_enemy = enemy_load.instantiate()
		new_enemy.position.x = global.enemy_spawn_area_posx + randf_range(50,80)
		new_enemy.position.y = global.enemy_spawn_area_posy + randf_range(50,80)
		global.enemy_spawn_area_posx = new_enemy.position.x
		global.enemy_spawn_area_posy = new_enemy.position.y 
	
		new_enemy.enemy_type = random_enemy()
		add_child(new_enemy)

func random_enemy():
	var random_enemy
	var i = randi_range(0,9)
	if i == 4 or i ==7 or i == 0:
		random_enemy = load("res://enemyRes/Skeleton.tres")
	else:
		random_enemy = load("res://enemyRes/Slime.tres")
	return random_enemy

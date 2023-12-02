extends Resource

class_name Base_Enemy
@export var is_dead =false
@export var attacking = false
@export var enemy_y_offset: int
var is_blocking = false
var player_crit = false
@export var name = "Enemy"
@export var texture :SpriteFrames
@export var health = 30
@export var damage = 8
@export var speed = 25
@export var heldItem :SlotData
@export var max_health = 30

func TakeDamage(damage : int) -> bool:
	var chance = randi_range(0,9)
	var block_chance = randi_range(0,9)
	if block_chance == 0 or block_chance == 1 or block_chance == 6:
		is_blocking = true
	elif chance == 1 or chance == 9 or chance == 3:
		player_crit = true
	
	if is_blocking and player_crit:
		#("I was here")
		health -= damage
		global.damage_delt = damage
	elif is_blocking:
		#("I was here")
		health -= damage/2
		global.damage_delt = damage/2
		is_blocking = false
	elif player_crit:
		#("I was here")
		health -= damage*1.5
		global.damage_delt = damage*1.5
		player_crit = false
	elif  not is_blocking:
		#("I was here")
		health -= damage
		global.damage_delt = damage
		
	if health <= 0:
		return true
	else: 
		return false
		
func Reset_Enemy():
	health = max_health
	

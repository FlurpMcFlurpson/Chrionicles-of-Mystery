extends Node
var is_dead:bool
var enemy_cirt:bool
var is_blocking:bool
var player
var player_curent_posx = 100
var player_curent_posy = 100
var current_health = 25
var max_health = 25
var damage = 10
var base_speed = 100
var player_name = "Player"
var moveable = true
var is_in_combat = false
var attacking = false
func use_slot_data(slot_data: SlotData):
	slot_data.item_data.use(player)
	
func TakeDamage(damage : int) -> bool:
	#(is_blocking)
	#(enemy_cirt)
	#(damage)
	var chance = randi_range(0,9)
	if not is_blocking:
		#("I was here")
		current_health -=damage
		global.damage_delt = damage
	elif chance == 1 or chance == 9 or chance ==3:
		#("I was here")
		enemy_cirt = true
	elif is_blocking and enemy_cirt:
		#("I was here")
		current_health -= damage
		global.damage_delt = damage
	elif is_blocking:
		#("I was here")
		current_health -= damage/2
		global.damage_delt = damage/2
		is_blocking = false
	elif enemy_cirt:
		#("I was here")
		current_health -= damage*1.5
		global.damage_delt = damage*1.5
		enemy_cirt = false
		
	if current_health <= 0:
		return true
	else: 
		return false

extends Node

var player
var player_curent_posx = 100
var player_curent_posy = 100
var current_health = 25
var max_health = 25
var base_damage = 10
var base_speed = 100
var player_name = "Player"
var moveable = true
var is_in_combat = false
var attacking = false
func use_slot_data(slot_data: SlotData):
	slot_data.item_data.use(player)
	


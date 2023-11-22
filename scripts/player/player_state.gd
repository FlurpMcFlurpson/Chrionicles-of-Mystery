extends Node

var player_curent_posx = 100
var player_curent_posy = 100
var current_health = 25
var max_health = 25
var base_damage = 10
var base_speed = 100
var player_name = "Player"
var experience_points = 0 
var stat_points = 0

#Stats
var vitality = 1
var agility = 1
var strength = 1
var defense = 1
var luck = 6



#leveling system
func leveling():
	if experience_points >= 1000:
		stat_points = stat_points+1
		experience_points = 0
	else: 
		pass

extends Node

var next_world
var next_world_name :String


@onready var player: CharacterBody2D = $world/player
@onready var inv_interface = $UI/Inv_interface
@onready var current_world = $world
@onready var anim = $AnimationPlayer
@onready var Menu = $UI/Menu_ui

# Called when the node enters the scene tree for the first time.
func _ready():
	current_world.connect("world_changed",self.handle_world_chagned)
	inv_interface.set_player_inv_data(player.inv_data)
	
	
	
func toggle_inv_interface():
	inv_interface.visible = not inv_interface.visible
	

func toggle_menu_interface():
	Menu.visible = not Menu.visible

func handle_world_chagned(current_world_name:String):
	print("singal Sent!!!!!!")
	print(current_world_name +" is the scene being exited")
	next_world_name = global.scene_entered
	print(next_world_name+" has be created")
	next_world = load("res://scenes/Maps/"+next_world_name+".tscn").instantiate()
	next_world.z_index = -1
	print(next_world.name+ " :is the newly loaded scene")
	add_child(next_world)
	anim.play("fade_in")
	next_world.connect("world_changed",self.handle_world_chagned)
	
	


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			global.last_scene_used = current_world.name
			print(current_world.name+" is delelted")
			current_world.queue_free()
			print("//////////////////////////////////")
			global.current_scene = next_world.name
			current_world = next_world
			current_world.z_index = 0
			next_world = null
			anim.play("fade_out")




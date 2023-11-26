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
	player.toggle_menu.connect(toggle_menu_interface)
	player.toggle_inv.connect(toggle_inv_interface)
	
func toggle_inv_interface():
	if Menu.visible:
		not inv_interface.visible
	else :
		inv_interface.visible = not inv_interface.visible
	

func toggle_menu_interface():
		Menu.visible = not Menu.visible

func handle_world_chagned(current_world_name:String):
	next_world_name = global.scene_entered
	next_world = load("res://scenes/Maps/"+next_world_name+".tscn").instantiate()
	print("testing")
	next_world.z_index = -1
	add_child(next_world)
	anim.play("fade_in")
	next_world.connect("world_changed",self.handle_world_chagned)
	
	


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			global.last_scene_used = current_world.name
			current_world.queue_free()
			global.current_scene = next_world.name
			current_world = next_world
			current_world.z_index = 0
			next_world = null
			anim.play("fade_out")




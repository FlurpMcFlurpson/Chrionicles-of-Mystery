extends Node

var next_world
var next_world_name :String


@onready var current_world = $world
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_world.connect("world_changed",self.handle_world_chagned)

func handle_world_chagned(current_world_name:String):
	match current_world_name:
		"world":
			next_world_name = global.scene_entered
		"coast":
			next_world_name = global.scene_entered
		_:
			return
	next_world = load("res://scenes/"+next_world_name+".tscn").instantiate()
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

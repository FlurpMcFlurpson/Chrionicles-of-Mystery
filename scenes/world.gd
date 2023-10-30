extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()


func _on_coast_portal_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func _on_coast_portal_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false


func change_scene():
	if global.transition_scene == true and global.current_scene == "world":
		get_tree().change_scene_to_file("res://scenes/coast.tscn")
		global.scene_changed()
		
	


func _on_forest_protal_body_entered(body):
	pass # Replace with function body.

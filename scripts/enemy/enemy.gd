
extends CharacterBody2D
var speed = 80
var player_follow = false
var player = null
var attacking = false
var player_in_Zone = false
@export var enemy_type: Base_Enemy
var testing = false


func _ready():
	$AnimatedSprite2D.sprite_frames = enemy_type.texture
	$AnimatedSprite2D.offset.y = enemy_type.enemy_y_offset
	
	
@warning_ignore("unused_parameter")
func _physics_process(delta):
	
	if player_follow:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif enemy_type.attacking:
		pass
	else:
		$AnimatedSprite2D.play("idle")
	move_and_slide()
		


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_follow = true

func _on_detection_area_body_exited(body):
	player = null
	player_follow = false
	
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player") and global.just_in_combat ==! true:
		player_in_Zone = true
		global.enemy_res = enemy_type
		global.transition_scene = true
		global.scene_entered = "combat_new"
		global.just_in_combat = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_Zone = false
		global.transition_scene = false






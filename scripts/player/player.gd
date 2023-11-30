extends CharacterBody2D
var enemy_Inragne = false
var enemy_cooldown =true
var alive = true
var SPEED = PlayerState.base_speed
var current_dir = "right"
var attacking = false
@export var inv_data: InventoryData


func _ready():
	PlayerState.player = self

func _physics_process(delta):
	if PlayerState.moveable == true:
		player_movement(delta)
	else :
		play_anim(0)
	current_cam()


func player_movement(delta):
	if Input.is_action_pressed("Right"):
		velocity.x = SPEED
		play_anim(1)
		current_dir = "right"
		velocity.y = 0
	elif Input.is_action_pressed("Left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("Down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = SPEED
		velocity.x = 0
	elif Input.is_action_pressed("Up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -SPEED
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	move_and_slide()
	

func  play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_side")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_side")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_down")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_up")
	if movement == 0:
		if attacking == false:
			anim.play("idle_side")

func  player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_Inragne = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_Inragne = false


func  current_cam():
	
	match global.current_scene:
		
		"world":
			$world_cam.enabled = true
			$coast_cam.enabled = false
		"coast":
			print("coastcam on")
			$world_cam.enabled = false
			$coast_cam.enabled = true
		"combat":
			$world_cam.enabled = false
			$coast_cam.enabled = false


func heal(healthRestored: int):
	if PlayerState.current_health <= PlayerState.max_health:
		PlayerState.current_health += healthRestored
		get_tree().call_group("combat","update_health")
		if  PlayerState.current_health > PlayerState.max_health:
			PlayerState.current_health = PlayerState.max_health
			get_tree().call_group("combat","update_health")
	else:
		return

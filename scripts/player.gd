extends CharacterBody2D

var enemy_Inragne = false
var enemy_cooldown =true
var health = 1000
var alive = true
const SPEED = 100.0
var current_dir = "right"
var attacking = false

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		alive = false
		health = 0
		#laod end scence when created.
		
		

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

func enemy_attack():
	if enemy_Inragne and enemy_cooldown == true:
		health = health - 20
		enemy_cooldown = false
		$Attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_cooldown = true


func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_attacking = true
		attacking = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_side")
			$player_clooldown.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_side")
			$player_clooldown.start()
		if dir == "down":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_down")
			$player_clooldown.start()
		if dir == "up":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_up")
			$player_clooldown.start()




func _on_player_clooldown_timeout():
	$player_clooldown.stop()
	global.player_attacking = false
	attacking = false

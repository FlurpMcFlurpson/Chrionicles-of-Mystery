extends CharacterBody2D

var speed = 40
var player_follow = false
var player = null
var health = 100
var player_in_Zone = false
var Iframes = false

@warning_ignore("unused_parameter")
func _physics_process(delta):
	deal_damge()
	
	if player_follow:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
		


func _on_detection_area_body_entered(body):
	player = body
	player_follow = true


@warning_ignore("unused_parameter")
func _on_detection_area_body_exited(body):
	player = null
	player_follow = false
	
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_Zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_Zone = false

func  deal_damge():
	if player_in_Zone and global.player_attacking == true:
		if Iframes == false:
			health = health - 20
			$damage_cooldown.start()
			Iframes = true
			print("Slime health = ", health )
		if health <= 0:
			self.queue_free()


func _on_damage_cooldown_timeout():
	Iframes = false

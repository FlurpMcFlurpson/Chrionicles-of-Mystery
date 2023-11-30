extends Node2D
signal world_changed(world_name)
@export var world_name = ""
var block_active = false
signal textbox_closed
var enemy_load = preload("res://scenes/enemy/enemy.tscn")
var current_player_health:int
var current_enemy_health:int
var current_enemy
@onready var player_ani = $player/AnimatedSprite2D
@onready var enemy_ani = $Enemy/AnimatedSprite2D

func _ready():
	PlayerState.moveable = false
	current_player_health = PlayerState.current_health
	await enemy_spawn()
	current_enemy = $Enemy.enemy_type
	current_enemy_health = current_enemy.health
	$Enemy/AnimatedSprite2D.flip_h = true
	$player/AnimatedSprite2D.flip_h = false
	set_health($CanvasLayer/PlayerContainer/ProgressBar, PlayerState.current_health, PlayerState.max_health)
	set_health($CanvasLayer/EnemyContainer/ProgressBar, current_enemy.health, current_enemy.health)
	$CanvasLayer/Panel/Action_text.hide()
	
func _process(delta):
	if PlayerState.moveable == true or $player/AnimatedSprite2D.flip_h == true:
		PlayerState.moveable = false
		$player/AnimatedSprite2D.flip_h = false
	
func  enemy_spawn():
	var new_enemy = enemy_load.instantiate()
	new_enemy.position.x = 767
	new_enemy.position.y = 379
	new_enemy.scale.x = 6
	new_enemy.scale.y = 6
	new_enemy.enemy_type = global.enemy_res
	add_child(new_enemy)

func _input(event):
	if Input.is_action_just_pressed("text_clear") and $CanvasLayer/Panel/Action_text/Label.visible:
		$CanvasLayer/Panel/Action_text.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$CanvasLayer/Panel/Action_text/Label.text = text
	$CanvasLayer/Panel/Action_text.show()

func set_health(progress_bar,health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]


func _on_attack_pressed():
	if PlayerState.base_speed >= current_enemy.speed:
		await  player_attack()
		enemy_attack()
	else:
		await enemy_attack()
		player_attack()

func _on_block_pressed():
	pass # Replace with function body.


func _on_items_pressed():
	get_tree().call_group("inv_group","Toggle_inv")


func _on_run_pressed():
	#display_text("Player got away safely!")
	#await(textbox_closed)
	global.scene_entered = global.last_scene_used
	global.transition_scene = true
	emit_signal("world_changed", world_name)
	global.transition_scene = false
	global.just_in_combat = false

func  update_player_health():
	print("heath updated")
	if current_player_health != PlayerState.current_health:
		current_player_health = PlayerState.current_health
		set_health($CanvasLayer/PlayerContainer/ProgressBar, current_player_health, PlayerState.max_health)


func player_attack():
	#check_end_combat()
	player_ani.play("attack_side")
	display_text("You swing your sword at %s" % current_enemy.name)
	await(textbox_closed)
	$DamageSound.play()
	current_enemy_health = max(0 ,  current_enemy_health - PlayerState.base_damage)
	set_health($CanvasLayer/EnemyContainer/ProgressBar, current_enemy_health, current_enemy.health)
	#$AnimationPlayer.play("ememy_damaged")
	#await($AnimationPlayer)
	display_text("You dealt %d damage!" % PlayerState.base_damage)
	await(textbox_closed)
	await check_end_combat()


func check_end_combat():
	if current_player_health == 0:
		#$AnimationPlayer.play("player_death")
		display_text("%s has been defeated" % PlayerState.player_name)
		await(textbox_closed)
		display_text("%s, better luck in your next life!" % PlayerState.player_name)
		await(textbox_closed)
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	if current_enemy_health == 0:
		enemy_ani.play("death")
		display_text("%s has been defeated" % current_enemy.name)
		await(textbox_closed)
		display_text("%s has droped an item!" % current_enemy.name)
		await (textbox_closed)
		await get_tree().create_timer(0.25).timeout
		PlayerState.current_health = current_player_health
		global.transition_scene = true
		global.scene_entered = global.last_scene_used
		emit_signal("world_changed", world_name)
		global.transition_scene = false
		global.just_in_combat = false

func enemy_attack():
	check_end_combat()
	display_text("%s attacks you with full force" % current_enemy.name)
	await(textbox_closed)
	$DamageSound.play()
	if block_active == true:
		current_player_health = max(0 , current_player_health - current_enemy.damage/2)
		block_active = false
		set_health($CanvasLayer/PlayerContainer/ProgressBar, current_player_health, PlayerState.max_health)
		#$AnimationPlayer.play("player_damaged")
		display_text("%s dealt %d damage!" % [current_enemy.name, current_enemy.damage/2])
		await(textbox_closed)
	else:
		current_player_health = max(0 , current_player_health - current_enemy.damage)
		set_health($CanvasLayer/PlayerContainer/ProgressBar, current_player_health, PlayerState.max_health)
		#$AnimationPlayer.play("player_damaged")
		display_text("%s dealt %d damage!" % [current_enemy.name, current_enemy.damage])
		await(textbox_closed)

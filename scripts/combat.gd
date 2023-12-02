extends Control
signal world_changed(world_name)
@export var world_name = ""
signal textbox_closed
@export var enemy: Resource
var current_player_health = 0
var current_enemy_health = 0
var block_active = false
var experice_gained = randf_range(50,200)
signal item_drop
var skeleton = preload("res://enemyRes/Skeleton.tres")
var slime = preload("res://enemyRes/Slime.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerContainer/ProgressBar, PlayerState.current_health, PlayerState.max_health)
	$EnemyContainer/Enemy.texture = enemy.texture
	$Panel/Action_text.hide()
	$BattleMusic.play()
	display_text("A wild %s apppers!" % enemy.name)
	current_enemy_health = enemy.health
	current_player_health = PlayerState.current_health


func set_enemy(enemy_name):
	#(enemy_name)
	match enemy_name:
		"Slime":
			#("Skeleton set")
			enemy = slime
		"Skeleton":
			#("Skeleton set")
			enemy = skeleton

func  update_health():
	#("heath updated")
	if current_player_health != PlayerState.current_health:
		current_player_health = PlayerState.current_health
		set_health($PlayerContainer/ProgressBar, current_player_health, PlayerState.max_health)



func set_health(progress_bar,health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]
	
	


func _input(event):
	if Input.is_action_just_pressed("text_clear") and $Panel/Action_text/Label.visible:
		$Panel/Action_text.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$Panel/Action_text/Label.text = text
	$Panel/Action_text.show()
	
	
func _on_run_pressed():
	display_text("Player got away safely!")
	await(textbox_closed)
	global.transition_scene = true
	global.scene_entered = global.last_scene_used
	emit_signal("world_changed", world_name)
	global.transition_scene = false
	global.just_in_combat = true

	


func enemy_attack():
	check_end_combat()
	display_text("%s attacks you with full force" % enemy.name)
	await(textbox_closed)
	$DamageSound.play()
	if block_active == true:
		current_player_health = max(0 , current_player_health - enemy.damage/2)
		block_active = false
		set_health($PlayerContainer/ProgressBar, current_player_health, PlayerState.max_health)
		$AnimationPlayer.play("player_damaged")
		display_text("%s dealt %d damage!" % [enemy.name, enemy.damage/2])
		await(textbox_closed)
	else:
		current_player_health = max(0 , current_player_health - enemy.damage)
		set_health($PlayerContainer/ProgressBar, current_player_health, PlayerState.max_health)
		$AnimationPlayer.play("player_damaged")
		display_text("%s dealt %d damage!" % [enemy.name, enemy.damage])
		await(textbox_closed)
	
	
	
func player_attack():
	#check_end_combat()
	$AnimationPlayer.play("player_attack")
	display_text("You swing your sword at %s" % enemy.name)
	await(textbox_closed)
	$DamageSound.play()
	current_enemy_health = max(0 ,  current_enemy_health - PlayerState.base_damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	$AnimationPlayer.play("ememy_damaged")
	#await($AnimationPlayer)
	display_text("You dealt %d damage!" % PlayerState.base_damage)
	await(textbox_closed)
	await check_end_combat()
	
	

func _on_attack_pressed():
	if PlayerState.base_speed >= enemy.speed:
		await  player_attack()
		enemy_attack()
	else:
		await enemy_attack()
		player_attack()
		
func check_end_combat():
	if current_player_health == 0:
		$AnimationPlayer.play("player_death")
		display_text("%s has been defeated" % PlayerState.player_name)
		await(textbox_closed)
		display_text("%s, better luck in your next life!" % PlayerState.name)
		await(textbox_closed)
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	if current_enemy_health == 0:
		$AnimationPlayer.play("enemy_death")
		display_text("%s has been defeated" % enemy.name)
		await(textbox_closed)
		display_text("%s has droped an item!" % enemy.name)
		await (textbox_closed)
		await get_tree().create_timer(0.25).timeout
		PlayerState.current_health = current_player_health
		global.transition_scene = true
		global.scene_entered = global.last_scene_used
		emit_signal("world_changed", world_name)
		global.transition_scene = false
		global.just_in_combat = false
		

func _on_block_pressed():
	block_active = true
	enemy_attack()


func _on_items_pressed():
	get_tree().call_group("inv_group","Toggle_inv")

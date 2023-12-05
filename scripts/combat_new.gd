extends Node2D
enum GameState {
	Start,
	Playerturn,
	Enemyturn,
	Win,
	LOST,
	RAN
}
@export var world_name = ""
signal world_changed(world_name)
signal textbox_closed
signal attacking()
var enemy_load = preload("res://scenes/enemy/enemy.tscn")
var block_active = false
var current_enemy
@export var state: GameState
func _ready():
	state = GameState.Start
	SetupCombat()
	handle_combat_animations()

func _process(delta):
	if PlayerState.moveable == true or $player/AnimatedSprite2D.flip_h == true:
		PlayerState.moveable = false
		$player/AnimatedSprite2D.flip_h = false
	handle_combat_animations()

func SetupCombat():
	PlayerState.moveable = false
	PlayerState.is_in_combat = true
	await enemy_spawn()
	current_enemy = $Enemy.enemy_type
	$Enemy/AnimatedSprite2D.flip_h = true
	set_health($CanvasLayer/PlayerContainer/ProgressBar, PlayerState.current_health, PlayerState.max_health)
	set_health($CanvasLayer/EnemyContainer/ProgressBar, current_enemy.health, current_enemy.max_health)
	$CanvasLayer/Panel/Action_text.hide()
	$BattleMusic.play()
	
	state = GameState.Playerturn
	PlayerTurn()
	

func  handle_combat_animations():
	if state == GameState.Playerturn and PlayerState.attacking:
		$player/AnimatedSprite2D.play("attack_side")
	else:
		$player/AnimatedSprite2D.play("idle_side")
	if state == GameState.Enemyturn and current_enemy.attacking:
		$Enemy/AnimatedSprite2D.play("attack")
	else:
		$Enemy/AnimatedSprite2D.play("idle")
	if state == GameState.Win and current_enemy.is_dead:
		$Enemy/AnimatedSprite2D.play("death")
	if state == GameState.LOST and PlayerState.is_dead:
		$player/AnimatedSprite2D.play("death")
		
func PlayerTurn():
	pass

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
	if state != GameState.Playerturn:
		return
	player_attack()

func player_attack():
	PlayerState.attacking = true
	var isDead:bool
	var miss_chance = randi_range(0,9)
	if miss_chance == 9 or miss_chance == 2 or miss_chance == 5:
		display_text("%s's attack misses!" % PlayerState.player_name)
		isDead=false
		await(textbox_closed)
		PlayerState.attacking = false
	else:
	#Damage the enemy
		isDead = current_enemy.TakeDamage(PlayerState.damage)
		update_enemy_health()
		display_text("You swing your sword at %s" % current_enemy.name)
		#emit_signal("attacking")
		$DamageSound.play()
		await(textbox_closed)
		PlayerState.attacking = false
		display_text("You dealt %d damage!" % global.damage_delt)
		#$AnimationPlayer.play("ememy_damaged")
		#await($AnimationPlayer)
		await(textbox_closed)
		#check if enemy is dead
	if isDead:
		current_enemy.is_dead = true
		state = GameState.Win
		EndCombat()
	else:
		state = GameState.Enemyturn
		enemy_attack()
	#change GameState


func EndCombat():
	if state == GameState.Win:
		display_text("%s has been defeated" % current_enemy.name)
		await(textbox_closed)
		#current_enemy.is_dead = false
		await get_tree().create_timer(0.25).timeout
		global.transition_scene = true
		global.scene_entered = global.last_scene_used
		emit_signal("world_changed", world_name)
		global.transition_scene = false
		global.just_in_combat = false
		PlayerState.attacking = false
	if state == GameState.LOST:
		display_text("%s has been defeated" % PlayerState.player_name)
		await(textbox_closed)
		#PlayerState.is_dead = false
		display_text("%s, better luck in your next life!" % PlayerState.player_name)
		await(textbox_closed)
		PlayerState.current_health = PlayerState.max_health
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
		PlayerState.attacking = false
		global.just_in_combat = false
	if state == GameState.RAN:
		display_text("Player got away safely!")
		await(textbox_closed)
		global.scene_entered = global.last_scene_used
		global.transition_scene = true
		emit_signal("world_changed", world_name)
		global.transition_scene = false
		global.just_in_combat = false
		PlayerState.attacking = false
	current_enemy.Reset_Enemy()

func _on_block_pressed():
	if state != GameState.Playerturn:
		return
	state = GameState.Enemyturn
	PlayerState.is_blocking = true
	enemy_attack()


func _on_items_pressed():
	get_tree().call_group("inv_group","Toggle_inv")


func enemy_attack():
	current_enemy.attacking = true
	var isDead:bool
	var miss_chance = randi_range(0,9)
	#(miss_chance)
	if miss_chance == 6 or miss_chance == 4 or miss_chance == 0:
		display_text("%s's attack misses!" % current_enemy.name)
		isDead=false
		current_enemy.attacking = false
	else:
		display_text("%s attacks you with full force" % current_enemy.name)
		await(textbox_closed)
		current_enemy.attacking = false
		isDead = PlayerState.TakeDamage(current_enemy.damage)
		$DamageSound.play()
		update_player_health()
		display_text("%s dealt %d damage!" % [current_enemy.name, global.damage_delt])
		await(textbox_closed)
	if isDead:
		PlayerState.is_dead = true
		state = GameState.LOST
		EndCombat()
	else:
		state = GameState.Playerturn
	
func _on_run_pressed():
	state = GameState.RAN
	EndCombat()

func  update_player_health():
	#("heath updated")
	set_health($CanvasLayer/PlayerContainer/ProgressBar, PlayerState.current_health, PlayerState.max_health)

func  update_enemy_health():
	#("heath updated")
	set_health($CanvasLayer/EnemyContainer/ProgressBar, current_enemy.health, current_enemy.max_health)
	
func _on_player_just_healed():
	state = GameState.Enemyturn
	update_player_health()
	display_text("%s was healed" % PlayerState.player_name)
	await(textbox_closed)
	enemy_attack()

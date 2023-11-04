extends Control
signal world_changed(world_name)
@export var world_name = "world"
signal textbox_closed
@export var enemy: Resource

var current_player_health = 0
var current_enemy_health = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerContainer/ProgressBar, PlayerState.current_health, PlayerState.max_health)
	$EnemyContainer/Enemy.texture = enemy.texture
	$Textbox/Label.hide()
	display_text("A wild %s apppers!" % enemy.name)
	
	current_enemy_health = enemy.health
	current_player_health = PlayerState.current_health


func set_health(progress_bar,health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]


func _input(event):
	if Input.is_action_just_pressed("text_clear") and $Textbox/Label.visible:
		$Textbox/Label.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$Textbox/Label.text = text
	$Textbox/Label.show()
	
func _on_run_pressed():
	display_text("Player got away safely!")
	await(textbox_closed)
	global.transition_scene = true
	global.scene_entered = global.last_scene_used
	emit_signal("world_changed", world_name)
	global.transition_scene = false

	


func enemy_turn():
	display_text("%s attacks you with full force" % enemy.name)
	await(textbox_closed)
	
	current_player_health = max(0 , current_player_health - enemy.damage)
	set_health($PlayerContainer/ProgressBar, current_player_health, PlayerState.max_health)
	$AnimationPlayer.play("player_damaged")
	await($AnimationPlayer)
	display_text("%s dealt %d damage!" % [enemy.name, enemy.damage])
	await(textbox_closed)
	
	
func _on_attack_pressed():
	$AnimationPlayer.play("player_attack")
	await($AnimationPlayer)
	display_text("You swing your sword at %s" % enemy.name)
	await(textbox_closed)
	current_enemy_health = max(0 , current_enemy_health - PlayerState.base_damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	$AnimationPlayer.play("ememy_damaged")
	await($AnimationPlayer)
	display_text("You dealt %d damage!" % PlayerState.base_damage)
	await(textbox_closed)
	
	if current_enemy_health == 0:
		display_text("%s has been defeated" % enemy.name)
		await(textbox_closed)
		$AnimationPlayer.play("enemy_death")
		await($AnimationPlayer)
		await get_tree().create_timer(0.25).timeout
		global.transition_scene = true
		global.scene_entered = global.last_scene_used
		emit_signal("world_changed", world_name)
		global.transition_scene = false
		
		
	enemy_turn()
	
	


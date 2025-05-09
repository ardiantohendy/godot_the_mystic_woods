extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var ui: CanvasLayer = $"../UI"

const SPEED = 100
var current_dir = "none"
var can_attack = true
var is_attacking = false


func _ready() -> void:
	animated_sprite_2d.play("front_idle")
	var spawn_name = GameState.target_spawn_name
	var spawn_node = get_tree().current_scene.get_node_or_null(spawn_name)
	if spawn_node:
		global_position = spawn_node.global_position

func _physics_process(delta: float) -> void:
	player_movement(delta)
	player_attack(delta)

func player_movement(delta: float) -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		return 
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -SPEED
	else:
		play_anim(0)
		velocity = Vector2.ZERO

	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	
	if dir == "right":
		animated_sprite_2d.flip_h = false
		if movement == 1:
			animated_sprite_2d.play("side_walk")
		elif movement == 0:
			animated_sprite_2d.play("side_idle")
			
	elif dir == "left":
		animated_sprite_2d.flip_h = true
		if movement == 1:
			animated_sprite_2d.play("side_walk")
		elif movement == 0:
			animated_sprite_2d.play("side_idle")
			
	elif dir == "down":
		animated_sprite_2d.flip_h = false
		if movement == 1:
			animated_sprite_2d.play("front_walk")
		elif movement == 0:
			animated_sprite_2d.play("front_idle")
			
	elif dir == "up":
		animated_sprite_2d.flip_h = false
		if movement == 1:
			animated_sprite_2d.play("back_walk")
		elif movement == 0:
			animated_sprite_2d.play("back_idle")

#PLAYER COMBAT SYSTEM

func player_attack(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and can_attack and not is_attacking:
		attack()

func attack():
	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO
	
	if current_dir == "right":
		attack_area.position = Vector2(20, 0)
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("side_attack")
	elif current_dir == "left":
		attack_area.position = Vector2(-20, 0)
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("side_attack")
	elif  current_dir == "up":
		attack_area.position = Vector2(0, -10)
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("back_attack")
	elif current_dir == "down":
		attack_area.position = Vector2(0, 10)
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("front_attack")
	
	attack_area.monitoring = true
	
	await get_tree().physics_frame
	
	for body in attack_area.get_overlapping_bodies():
		if body.has_method("take_damage"):
			var direction_to_enemy = (body.global_position - global_position).normalized()
			body.take_damage(50, direction_to_enemy)
			
	await animated_sprite_2d.animation_finished  

	attack_area.monitoring = false
	is_attacking = false
	can_attack = true
	
#PLAYER GET ATTACK

func take_damage_from_enemy(amount):
	GameState.player_health -= amount
	ui.update_health(GameState.player_max_health ,GameState.player_health)
	if GameState.player_health <= 0:
		die()

func die():
	GameState.player_health = 150
	get_tree().reload_current_scene()	

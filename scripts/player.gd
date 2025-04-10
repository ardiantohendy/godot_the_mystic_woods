#var enemy_in_attack_range = false
#var enemy_attack_cooldown = true
#var health = 100
#var player_alive = true

#func player():
	#pass
#
#func _on_player_hit_box_body_entered(body: Node2D) -> void:
	#if body.has_method("enemy"):
		#enemy_in_attack_range = true
		#
#
#func _on_player_hit_box_body_exited(body: Node2D) -> void:
	#if body.has_method("enemy"):
		#enemy_in_attack_range = false
		#
		#
#func enemy_attack():
	#if enemy_in_attack_range and enemy_attack_cooldown:
		#health = health - 20
		#enemy_attack_cooldown = false
		#$EnemyAttackCooldown.start()
		#print("Player get damage. " + "Player health: ", health)
	#
#
#func _on_enemy_attack_cooldown_timeout() -> void:
	#enemy_attack_cooldown = true

extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea

const SPEED = 100
var current_dir = "none"

var can_attack = true

func _ready() -> void:
	animated_sprite_2d.play("front_idle")

func _physics_process(delta: float) -> void:
	player_movement(delta)

func player_movement(delta: float) -> void:
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
		velocity.x = 0
		velocity.y = 0
		
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


func _input(event):
	if event.is_action_pressed("attack") and can_attack:
		attack()

func attack():
	var dir = current_dir
	can_attack = false
	velocity = Vector2.ZERO
	if dir == "right":
		animated_sprite_2d.play("side_attack")
	elif dir == "up":
		animated_sprite_2d.play("back_attack")
	elif dir == "down":
		animated_sprite_2d.play("front_attack")
	else:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("side_attack")
		
	attack_area.monitoring = true
	
	await animated_sprite_2d.animation_finished
	
	attack_area.monitoring = false
	can_attack = true
	
	

extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
	
const SPEED = 100
var current_dir = "none"

func _ready() -> void:
	animated_sprite_2d.play("side_idle")

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

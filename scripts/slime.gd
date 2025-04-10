extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 40
var player_chased = false
var player = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	player_chased = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	player = null
	player_chased = false
	
func _physics_process(delta: float) -> void:
	if player_chased:
		chasing()
	else:
		patroling()
	
	move_and_slide()
	
func patroling():
	animated_sprite.play("side_idle")

func chasing():
	var direction = (player.global_position - global_position).normalized()
	
	if position.distance_to(player.position) > 10:
		position += (player.position - position)/SPEED
		walk_animation(direction)
	
	

func walk_animation(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animated_sprite.flip_h = false
			animated_sprite.play("side_walk")
		else:
			animated_sprite.flip_h = true
			animated_sprite.play("side_walk")
	else:
		if direction.y > 0:
			animated_sprite.play("front_walk")
		else:
			animated_sprite.play("back_walk")

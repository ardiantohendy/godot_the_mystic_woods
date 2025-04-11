extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

var SPEED = 20
var player_chased = false
var player = null
var patrol_points: Array[Vector2] = []
var current_point = 0
var health = 100
var get_attack = false

#patrolling by default
func _on_ready() -> void:
	for marker in $PatrolPath.get_children():
		if marker is Marker2D:
			patrol_points.append(marker.global_position)

func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	player_chased = true
	SPEED = 50
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	player = null
	player_chased = false
	SPEED = 20
	
func _physics_process(delta: float) -> void:
	if get_attack:
		if health <= 0:
			die_anim()
		else:
			attacked_anim()
		
		move_and_slide()
		return
		
	if player_chased:
		chasing()
	else:
		patroling()
	
	move_and_slide()
	
func patroling():
	if patrol_points.is_empty():
		return

	var target = patrol_points[current_point]
	var direction = (target - position).normalized()
	velocity = direction * SPEED
	walk_animation(direction)
	
	if position.distance_to(target) < 10:
		current_point = (current_point + 1) % patrol_points.size()
	
func chasing():
	var direction = (player.global_position - global_position).normalized()
	var distance = global_position.distance_to(player.global_position)
	
	if distance > 15:
		velocity = direction * SPEED
		walk_animation(direction)
	else :
		velocity = Vector2.ZERO 
		animated_sprite.play("side_idle")
	
func walk_animation(direction):
	if direction.length() == 0:
		return
	
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
			
#ENEMY COMBAT SYSTEM

func take_damage(amount, from_direction: Vector2):
	get_attack = true
	health -= amount
	
	# Efek knockback
	var knockback_force = 50
	velocity = from_direction.normalized() * knockback_force

func attacked_anim():
	if get_attack:
		animated_sprite.play("side_get_attack")
		
		# Tunggu sebentar biar knockback kelihatan
		await get_tree().create_timer(0.2).timeout
		
		velocity = Vector2.ZERO  # Hentikan setelah mental
		await animated_sprite.animation_finished
		
		get_attack = false
			
func die_anim():
	if get_attack:
		animated_sprite.play("dead")
		await animated_sprite.animation_finished
		get_attack = false
		queue_free()

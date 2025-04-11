extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea


var SPEED = 20
var player_chased = false
var player = null
var patrol_points: Array[Vector2] = []
var current_point = 0
var health = 100
var get_attack = false
#var can_attack = true
#var attack_cooldown = 1.5

#patrolling by default
func _on_ready() -> void:
	$AttackArea.monitoring = true
	$AttackArea.monitorable = true
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
	
	#check_attack()
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
		#SEHARUSNYA DI SINI GW KASIH ATTACK SOALNYA INI PAS SLIME BERHENTI DI DEKET PLAYER
		velocity = Vector2.ZERO 
		
		if abs(direction.x) > abs(direction.y):
			animated_sprite.play("side_idle")
		else:
			if direction.y > 0:
				animated_sprite.play("front_idle")
			else:
				animated_sprite.play("back_idle")

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
	var direction = (player.global_position - global_position).normalized()
	
	if get_attack:
		if abs(direction.x) > abs(direction.y):
			animated_sprite.play("side_get_attack")
		else:
			if direction.y > 0:
				animated_sprite.play("front_get_attack")
			else:
				animated_sprite.play("back_get_attack")
		
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

#ENEMY ATTACK PLAYER

#func check_attack():
	#if not can_attack or not is_instance_valid(player):
		#return
#
	#var bodies = $AttackArea.get_overlapping_bodies()
	#for body in bodies:
		#if body.is_in_group("player"): # pastikan nama node player kamu adalah "Player"
			#attack(body)
			#break
#
#func attack(player_node):
	#can_attack = false
#
	##if animated_sprite.has_animation("side_attack"):
		##animated_sprite.play("side_attack")
#
	## Kasih damage langsung, tanpa nunggu animasi selesai
	#if player_node.has_method("take_damage"):
		#player_node.take_damage(20)
#
	## Timer untuk cooldown serangan
	#var timer = get_tree().create_timer(attack_cooldown)
	#timer.timeout.connect(func(): can_attack = true)
		#
	

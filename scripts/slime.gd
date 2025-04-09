extends CharacterBody2D

@export var speed: float = 20.0
@export var patrol_points: Array[Vector2] = []

var current_point = 0
var player: Node2D = null
var state = "patrolling"

func _ready() -> void:
	$Area2D.body_entered.connect(_on_area_body_entered)
	$Area2D.body_exited.connect(_on_area_body_exited)
	
	var points = $PatrolPath.get_children()
	for point in points:
		if point is Marker2D:
			patrol_points.append(point.global_position)
	
func _physics_process(delta: float) -> void:
	match state:
		"patrolling":
			_patrol()
		"chasing":
			_chase_player()

func _patrol():
	if patrol_points.is_empty():
		return

	var target = patrol_points[current_point]
	var direction = (target - position).normalized()
	velocity = direction * speed
	move_and_slide()
	_play_walk_animation(direction)
	speed = 20.0

	if position.distance_to(target) < 10:
		current_point = (current_point + 1) % patrol_points.size()

func _chase_player():
	if player:
		var direction = (player.global_position - global_position).normalized()
		speed = 50.0
		velocity = direction * speed
		move_and_slide()
		_play_walk_animation(direction)

func _on_area_body_entered(body):
	if body.name == "Player":
		player = body
		state = "chasing"

func _on_area_body_exited(body):
	if body == player:
		player = null
		state = "patrolling"

func _play_walk_animation(direction: Vector2):
	var sprite = $AnimatedSprite2D
	if direction.length() == 0:
		return

	# Menentukan arah animasi
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			sprite.play("side_walk")
			sprite.flip_h = false
		else:
			sprite.play("side_walk")
			sprite.flip_h = true
	else:
		if direction.y > 0:
			sprite.play("front_walk")
		else:
			sprite.play("back_walk")

#
#extends CharacterBody2D
#
#const SPEED = 40
#var current_dir = "none"
#var player_chased = false
#var player = null
#@onready var animated_sprite = $AnimatedSprite2D
#
#func _physics_process(delta: float) -> void:
	#if player_chased:
		#if position.distance_to(player.position) > 10:
			#position += (player.position - position)/SPEED
			##animated_sprite.play("side_walk")
					#
			#if (player.position.x - position.x) < 0:
				#animated_sprite.flip_h = true
			#elif (player.position.x - position.x) > 0:
				#animated_sprite.flip_h = false
			#
			#if (player.position.y - position.y) < 0:
				#animated_sprite.play("back_walk")
			#elif (player.position.y - position.y) > 0:
				#animated_sprite.play("front_walk")
			#
			##if (player.position.y - position.y) < 0:
				##animated_sprite.play("back_idle")
	#else:
		#animated_sprite.play("side_idle")
	#
	#move_and_slide()
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("Body Entered")
	#player = body
	#player_chased = true
	#print(player, player_chased)
	#
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#print("Body Exited")
	#player = null
	#player_chased = false
	#print(player, player_chased)

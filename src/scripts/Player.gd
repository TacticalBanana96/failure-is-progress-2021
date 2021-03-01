extends KinematicBody2D

const ACCELERATION = 600
const MAX_SPEED = 100
const FRICTION = 600
var _velocity = Vector2.ZERO


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hand = $Hand

export(NodePath) var spawnPositionPath
var spawnPosition = Vector2()

func _ready() -> void:
	spawnPosition = get_node(spawnPositionPath).global_position
	animationPlayer.play("Spawn")
	yield(animationPlayer, "animation_finished")

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_released("die"):
	#	die(true)
	var direction: = get_direction()
	if direction != Vector2.ZERO:
		animationTree.set("parameters/Walk/blend_position", direction)
		animationState.travel("Walk")
		angle_face(direction, hand)
		_velocity = _velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		_velocity = Vector2.move_toward(Vector2.ZERO, FRICTION * delta)	
	move()

func get_direction() -> Vector2:
	return Vector2(
	int(Input.get_action_strength("move_right")) - int(Input.get_action_strength("move_left")),
	int(Input.get_action_strength("move_down")) - int(Input.get_action_strength("move_up"))
	).normalized()
	

func angle_face(vector: Vector2, hand: Position2D):
		var temp_vector = Vector2(vector.y * -1, vector.x)
		temp_vector.angle()
		hand.position = Vector2(vector.x * 20, vector.y * 20)
	
func move() -> void:
	move_and_slide(_velocity)

func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	acceleration: int
) -> Vector2:
	var out = linear_velocity
	out = acceleration * direction.normalized()
	return out

func die(spawn: bool) -> void:
	#send off player died signal with current position, (to spawn dead body with)
	#move player back to original screen
	Events.emit_signal("player_died", position, spawn)
	position = spawnPosition
	animationPlayer.play("Spawn")
	yield(animationPlayer, "animation_finished")
	
	#queue_free()


func _on_EnemyHitDetector_body_entered(body: Node) -> void:
	var spawn = true
	if body.is_in_group('enemy'):
		if body.is_in_group('bigboss'):
			spawn = false
			die(spawn)
			return
		elif body.is_in_group('bomb'):
			spawn = false
		Events.emit_signal("hit_enemy", body)
		die(spawn)
	elif body.is_in_group('checkpoint'):
		spawnPosition = body.global_position
		Events.emit_signal("checkpoint", body)


extends KinematicBody2D

const ACCELERATION = 600
const MAX_SPEED = 100
const FRICTION = 600
var _velocity = Vector2.ZERO


export(NodePath) var spawnPositionPath
var spawnPosition = Vector2()

func _ready() -> void:
	spawnPosition = get_node(spawnPositionPath).global_position

func _physics_process(delta: float) -> void:

	if Input.is_action_just_released("die"):
		die()
	var direction: = get_direction()
	if direction != Vector2.ZERO:
		angle_face(direction)
		_velocity = _velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		_velocity = Vector2.move_toward(Vector2.ZERO, FRICTION * delta)	
	move()

func get_direction() -> Vector2:
	return Vector2(
	int(Input.get_action_strength("move_right")) - int(Input.get_action_strength("move_left")),
	int(Input.get_action_strength("move_down")) - int(Input.get_action_strength("move_up"))
	).normalized()
	

func angle_face(vector: Vector2):
		var temp_vector = Vector2(vector.y * -1, vector.x)
		rotation = temp_vector.angle()
	
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

func die() -> void:
	#send off player died signal with current position, (to spawn dead body with)
	#move player back to original screen
	Events.emit_signal("player_died", position)
	position = spawnPosition
	#queue_free()


func _on_EnemyHitDetector_body_entered(body: Node) -> void:
	if body.is_in_group('enemy'):
		Events.emit_signal("hit_enemy", body)
		die()

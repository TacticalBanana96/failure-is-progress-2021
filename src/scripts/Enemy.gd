extends KinematicBody2D

var _velocity: Vector2 = Vector2.ZERO
var speed: float = 100

export var direction: Vector2 = Vector2.UP
export var score: = 100
export var health: int = 1

func _ready() -> void:
	Events.connect("hit_enemy", self, "_on_enemy_hit")
	set_physics_process(false)
	_velocity = direction.normalized() * speed
	#_velocity.x = -1 * speed

func _on_enemy_hit(enemy) -> void:
	if enemy.name == self.name:
		health -= 1
		if health <= 0:
			die()

func _physics_process(delta: float) -> void:
	print(_velocity)
	if is_on_wall():
		_velocity = _velocity * -1.0
	move_and_slide(_velocity)
	#_velocity.y = move_and_slide(_velocity).y
	

func die() -> void:
	queue_free()


func _on_PlayerDetector_body_entered(body: Node) -> void:
	pass
	#if body.name == 'Player':
		#TODO get rid of this
	#	return
		#TODO run away
	#	print("RUNWAY FROM", body.position)
	#	var direction = (self.global_position - body.global_position).normalized()
	#	_velocity = direction * speed

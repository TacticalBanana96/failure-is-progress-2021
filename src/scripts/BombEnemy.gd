extends KinematicBody2D

var _velocity: Vector2 = Vector2.ZERO
var speed: float = 100

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

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
	print("BOMB",_velocity)
	if is_on_wall():
		_velocity = _velocity * -1.0
	if _velocity != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", direction)
		animationTree.set("parameters/Run/blend_position", direction)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
		
	move_and_slide(_velocity)
	#_velocity.y = move_and_slide(_velocity).y


func die() -> void:
	queue_free()

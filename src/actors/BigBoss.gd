extends KinematicBody2D

var BOMB = preload("res://src/actors/BombEnemy.tscn")

onready var spawnTimer = $Timer
onready var pathFollow = get_parent()
onready var animationPlayer = $AnimationPlayer
export var speed: float = 100
export var direction: Vector2 = Vector2.UP
export var score: = 100
export var health: int = 4

var moveDirection := 0.0
var spawnPosition = Vector2()
var _velocity: Vector2 = Vector2.ZERO


var orbitingBombsCount = 0
var spawning = false


func movementLoop(delta):
	var prepos = pathFollow.get_global_position()
	pathFollow.set_offset(pathFollow.get_offset() + speed * delta)
	var pos = pathFollow.get_global_position()
	moveDirection = (pos.angle_to_point(prepos)/ 3.14) *180


func _ready() -> void:
	Events.connect("hit_enemy", self, "_on_enemy_hit")
	set_physics_process(false)
	#_velocity = direction.normalized() * speed
	#_velocity.x = -1 * speed

func _on_enemy_hit(enemy) -> void:
	if enemy.name == self.name:
		health -= 1
		animationPlayer.play("Damage")
		yield(animationPlayer, "animation_finished")
		animationPlayer.play("WalkDown")
		if health <= 0:
			die()

func _physics_process(delta: float) -> void:
	
	orbitingBombsCount = countBombs()
	if orbitingBombsCount == 0 && spawning == false:
		spawning = true
		startSpawnTimer(5)
	movementLoop(delta)
	#_velocity = direction * speed
	#if is_on_wall():
	#	_velocity = _velocity * -1.0

	#move_and_slide(_velocity)
	#_velocity.y = move_and_slide(_velocity).y

func startSpawnTimer(time) ->void:
	spawnTimer.set_wait_time(time)
	spawnTimer.set_one_shot(true)
	spawnTimer.start()
	
func die() -> void:
	Events.emit_signal('win')
	queue_free()

func countBombs() -> int:
	return $OrbitController.get_children().size()


func _on_Timer_timeout() -> void:
	spawnBombs()
	spawnBombs()
	spawning = false

func get_direction(movePoint)-> Vector2:
	return (movePoint.get_global_position() - self.get_global_position()).normalized()

func spawnBombs():
	print(position)
	var pos = Vector2(position)
	var instanceOfObject = BOMB.instance()
	instanceOfObject.set_position(pos)
	instanceOfObject.z_index = 1
	var spawnedContainer = $OrbitController
	spawnedContainer.add_child(instanceOfObject)

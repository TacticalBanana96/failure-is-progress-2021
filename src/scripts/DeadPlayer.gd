extends KinematicBody2D

var picked = false
onready var animator = $AnimationPlayer

func _ready() -> void:
	animator.play("Idle")

func _on_EnemyHitDetector_body_entered(body: Node) -> void:
	if body.is_in_group('enemy'):
		Events.emit_signal("hit_enemy", body)
		die()
	if body.is_in_group('door'):
		Events.emit_signal("hit_door", body)
		die()

func _physics_process(delta: float) -> void:
	if picked == true:
		self.position = get_tree().get_root().get_node("TestLevel/Player/Hand").global_position

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pickup"):
		if picked == false:
			var bodies = $detector.get_overlapping_bodies()
			for b in bodies:
				print(b.name)
				if b.name == 'Player':
					picked = true
		else:
			picked = false
			#TODO DROP ITEM
				

func die() -> void:
	queue_free()

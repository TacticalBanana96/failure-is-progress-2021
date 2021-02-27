extends KinematicBody2D

var picked = false


func _physics_process(delta: float) -> void:
	if picked == true:
		print("Picked true")
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
				

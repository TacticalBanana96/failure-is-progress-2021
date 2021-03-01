extends KinematicBody2D

onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
func _ready() -> void:
	Events.connect("checkpoint", self, "on_checkpoint")
	
func on_checkpoint(checkpoint) -> void:
	if checkpoint.name == self.name:
		die()

func die()-> void:
	audioPlayer.play()
	$Sprite.visible = false
	$CollisionShape2D.disabled = true
	yield(audioPlayer, "finished")
	queue_free()

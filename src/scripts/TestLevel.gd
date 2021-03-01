extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("lose", self, "on_lose")
	Events.connect("win", self, "on_win")
	
func on_lose() -> void:
	#fade out
	get_tree().change_scene("res://src/screens/LoseScreen.tscn")
	queue_free()
	
func on_win() -> void:
	#fade out
	get_tree().change_scene("res://src/screens/WinScreen.tscn")
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

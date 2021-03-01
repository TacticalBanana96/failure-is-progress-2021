extends Node

const DEAD_PLAYER = preload("res://src/actors/DeadPlayer.tscn")


func _ready() -> void:
	Events.connect("player_died", self, "on_player_died_spawn_corpse") 

func on_player_died_spawn_corpse(position, spawn):
	if spawn == true:
		spawn(DEAD_PLAYER, position)
		Events.emit_signal("CorpseSpawned")
	
func spawn(object, position):
	print(position)
	var pos = Vector2(position)
	var instanceOfObject = object.instance()
	instanceOfObject.set_position(pos)
	instanceOfObject.z_index = 1
	var spawnedContainer = get_node("Container") 
	spawnedContainer.add_child(instanceOfObject)

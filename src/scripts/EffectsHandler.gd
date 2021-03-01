extends Node
const BLOOD_PARTICLES = preload("res://src/effects/blood_particles.tscn")
const EXPLOSION_PARTICLES = preload("res://src/effects/ExplosionParticle.tscn")
const HIT_AUDIO = preload("res://src/effects/HitAudio.tscn")
const SOFTER_HIT_AUDIO = preload("res://src/effects/SofterHitAudio.tscn")
const EXPLOSION_AUDIO = preload("res://src/effects/ExplosionAudio.tscn")


var bloodParticle
var explosionParticle
var hitAudio
var explosionAudio
var softerHitAudio

func _ready() -> void:
	Events.connect("hit_enemy", self, "on_hit_enemy")
	Events.connect("hit_door", self, "on_hit_door")
	bloodParticle = spawn(BLOOD_PARTICLES, Vector2.ZERO)
	explosionParticle = spawn(EXPLOSION_PARTICLES, Vector2.ZERO)
	hitAudio = spawn(HIT_AUDIO, Vector2.ZERO)
	explosionAudio = spawn(EXPLOSION_AUDIO, Vector2.ZERO)
	softerHitAudio = spawn(SOFTER_HIT_AUDIO, Vector2.ZERO)
	

func on_hit_door(door):
	softerHitAudio.position = door.global_position
	softerHitAudio.playing = true

func on_hit_enemy(enemy):
	if enemy.is_in_group('bomb'):
		explosionParticle.position = enemy.global_position
		explosionParticle.emitting = true
		explosionAudio.position = enemy.global_position
		explosionAudio.playing = true
	else:
		bloodParticle.position = enemy.global_position
		hitAudio.position = enemy.global_position
		hitAudio.playing = true
		bloodParticle.emitting = true
		
		
func spawn(object, position: Vector2):
	var instanceOfObject = object.instance()
	instanceOfObject.set_position(position)
	instanceOfObject.z_index = 1
	var spawnedContainer = get_node("Container") 
	spawnedContainer.add_child(instanceOfObject)
	return instanceOfObject
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

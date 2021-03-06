extends Node

var score := 0 setget set_score
var deaths := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("score_updated", self, "set_score")
	Events.connect("player_died", self, "increment_deaths")
	Events.connect("win", self, "clear")
	Events.connect("lose", self, "clear")

func clear():
	score = 0
	deaths = 0

func set_score(currentScore: int) -> void:
	score = currentScore
	
func increment_deaths(position, spawn) -> void:
	deaths += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

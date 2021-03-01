extends Node


var usableSupplies = 0
var corpses = 0 

var suppliesroom1 = 1
var suppliesroom2 = 2
var suppliesroom3 = 1
var suppliesroom4 = 2
var suppliesroom5 = 2
var suppliesroom6 = 6

var remainingNonBombsInOpenRooms: int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	usableSupplies += suppliesroom1
	print('USABLE',usableSupplies)
	Events.connect("hit_enemy", self, "update_supplies")
	Events.connect("hit_door", self, "update_supply_total")
	Events.connect("CorpseDestroyed", self, "decrement_corpse")
	Events.connect("CorpseSpawned", self, "increment_corpse")

func _process(delta: float) -> void:
	#print('STATS', usableSupplies, ' ', corpses)
	if usableSupplies == 0 && corpses == 0:
		Events.emit_signal('lose')

func increment_corpse() -> void:
	corpses += 1
	print('COPRSE',corpses)

func decrement_corpse() -> void:
	corpses -= 1
	print('COPRSE',corpses)

func update_supplies(enemy):
	if enemy.is_in_group('enemy') && !enemy.is_in_group('bomb')  && !enemy.is_in_group('bigboss'):
		usableSupplies -= 1

func update_supply_total(door):
	match door.name:
		"Door":
				usableSupplies += suppliesroom2
		"Door2":
				usableSupplies += suppliesroom3
		"Door3":
				usableSupplies += suppliesroom4
		"Door4":
				usableSupplies += suppliesroom5
		"Door5":
				usableSupplies += suppliesroom6
	
func nonBombChildrenCount(node) -> int: 
	var count = 0
	var children = node.get_children()
	for c in children:
		if c.is_in_group('enemy') && !c.is_in_group('bomb')  && !c.is_in_group('bigboss'):
			count += 1
	return count
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

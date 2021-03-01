extends RichTextLabel

onready var scene_tree: = get_tree()

var dialog = ["Those filthy humans have invaded our dungeon ",
				"They think themselves heroes but they only come to destroy ",
				"Rid our home from those filthy monters "]
var page = 0
var paused = false

func _ready() -> void:
	#pause game
	paused = not paused
	scene_tree.paused = paused
	set_bbcode(dialog[page])
	set_visible_characters(0)
	set_process_input(true)
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size() -1:
				page += 1
				set_bbcode(dialog[page])
				set_visible_characters(0)
			else: 
				die()
		else:
			set_visible_characters(get_total_character_count())

func die():
	paused = not paused
	scene_tree.paused = paused
	var container = get_parent()	
	container.queue_free()		
	
func _on_Timer_timeout() -> void:
	set_visible_characters(get_visible_characters()+1)


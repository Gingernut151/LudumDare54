extends Node

# (optional) icon to show in the editor dialogs:
@icon("res://path/to/optional/icon.svg")

@export var
 
func _run():
	var screen_size = DisplayServer.screen_get_size()
	var window = get_editor_interface().get_window()
	window.mode = Window.MODE_WINDOWED
	window.position = Vector2i(-8, 0)
	window.size = Vector2i(screen_size.x - 66, screen_size.y - 1)
	window.unresizable = true
	window.title = "Andy's a noob at life"
	window.borderless = true
	window.always_on_top = true



# Called when the node enters the scene tree for the first time.
func _ready():
	_run()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

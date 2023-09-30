extends Node

#@icon("res://path/to/optional/icon.svg")

@export var main_scene: PackedScene

@onready var Tex_Archie = $Archie

var CurrentScalePercentage = 100.0
var ScreenScaleSpeed = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	_run()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_WubTheScreen(delta)
	pass

 
func _run():
	var screen_size = DisplayServer.screen_get_size()
	var window = get_window()
	window.mode = Window.MODE_WINDOWED
	window.position = Vector2i(0, 0)
	window.size = Vector2i(screen_size.x, screen_size.y)
	window.unresizable = true
	window.title = "Andy's a noob at life"
	window.borderless = true
	window.always_on_top = true
	
func _WubTheScreen(delta):
	
	CurrentScalePercentage -= (delta * ScreenScaleSpeed)
	
	if CurrentScalePercentage < -100.0:
		CurrentScalePercentage += 200.0
	
	
	var screen_size = DisplayServer.screen_get_size()
	var NewScreen_size = DisplayServer.screen_get_size()
	var window = get_window()
	NewScreen_size.x = screen_size.x * (abs(CurrentScalePercentage) / 100)
	NewScreen_size.y = screen_size.y * (abs(CurrentScalePercentage) / 100)

	window.size = Vector2i(NewScreen_size.x, NewScreen_size.y)
	window.position = Vector2i((screen_size.x - NewScreen_size.x) / 2, (screen_size.y - NewScreen_size.y) / 2 )

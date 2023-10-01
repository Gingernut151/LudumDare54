extends Control

signal NextMap
signal RetryMap
signal QuitMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func ShowwGameOverMenu(InState : bool):
	if InState:
		$CanvasLayer.show()
	else:
		$CanvasLayer.hide()


func _on_btn_resume_button_up():
	NextMap.emit()
	pass # Replace with function body.


func _on_btn_restart_button_up():
	RetryMap.emit()
	pass # Replace with function body.


func _on_btn_quit_button_up():
	QuitMap.emit()
	pass # Replace with function body.

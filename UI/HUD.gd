extends Control

signal On_Resume_Pressed
signal On_Restart_Pressed
signal On_Quit_Pressed

func _on_ready():
	ShowwInGameHUD(false)
	pass # Replace with function body.
	
#=============================================
# In Game HUD
#=============================================	

func ShowwInGameHUD(InState : bool):
	
	if InState:
		$Canvas_Ingame.show()
	else:
		$Canvas_Ingame.hide()

func update_debugtext(inLocation):
	$Canvas_Ingame/DistanceAway.text = str(inLocation)

#=============================================
# Pause Menu
#=============================================	

func ShowwPauseMenu(InState : bool):
	
	if InState:
		ShowwInGameHUD(false)
		$Canvas_Pause.show()
	else:
		ShowwInGameHUD(true)
		$Canvas_Pause.hide()

#=============================================
# Signals
#=============================================	

func _on_btn_resume_button_up():
	On_Resume_Pressed.emit()
	pass # Replace with function body.


func _on_btn_restart_button_up():
	On_Restart_Pressed.emit()
	pass # Replace with function body.


func _on_btn_quit_button_up():
	On_Quit_Pressed.emit()
	pass # Replace with function body.

extends Node

var isInFrontend : bool = true
var isPaused : bool = false
var isGameOver : bool = false

#=============================================
# Pre defined
#=============================================	

# Called when the node enters the scene tree for the first time.
func _ready():
	HandleFrontendShown(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !isInFrontend:
		var MinimalPathNeeded = $Level_01.GetMinimalPathAmount($Character.get_position());
	
		$HUD.update_debugtext(MinimalPathNeeded)
		$Character.UpdateCellNeededToMove(MinimalPathNeeded)
	
		if Input.is_action_just_pressed("Pause"):
			HandlePauseState(!isPaused)
	else:
		if Input.is_action_just_pressed("Pause"):
			get_tree().quit()

#=============================================
# General
#=============================================	

func HandleFrontendShown(inState : bool):
	$Frontend.ShowFrontend(inState)
	$HUD.ShowwPauseMenu(false)
	$HUD.ShowwInGameHUD(!inState)
	isInFrontend = inState
	
	if (isInFrontend):
		$Character.hide()
		$Level_01.hide()
	else:
		$Character.show()
		$Level_01.show()

func HandlePauseState(InState : bool):
	isPaused = InState
	$HUD.ShowwPauseMenu(isPaused)
	
func ResetMap():
	$Character.setStartPos($Level_01.CharacterStartLocation)
	pass


#=============================================
# Signals
#=============================================	

func _on_frontend_start_game():
	ResetMap()
	HandleFrontendShown(false)
	pass # Replace with function body.

func _on_frontend_quit_game():
	get_tree().quit()
	pass # Replace with function body.


func _on_hud_on_quit_pressed():
	HandleFrontendShown(true)
	pass # Replace with function body.


func _on_hud_on_restart_pressed():
	ResetMap()
	HandlePauseState(false)
	pass # Replace with function body.


func _on_hud_on_resume_pressed():
	HandlePauseState(false)
	pass # Replace with function body.

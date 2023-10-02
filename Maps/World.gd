extends Node

var isInFrontend : bool = true
var isPaused : bool = false
var isGameOver : bool = false
var CurrentMapIndex : int = 1

@export var LevelGenerateScene: PackedScene
var CurrentLevelMap : Node2D


var LevelLayouts = {
	1: "res://Maps/Layouts/Level_01.txt",
	2: "res://Maps/Layouts/Level_02.txt",
	3: "res://Maps/Layouts/Level_03.txt",
	4: "res://Maps/Layouts/Level_04.txt",
	5: "res://Maps/Layouts/Level_05.txt",
}

#=============================================
# Pre defined
#=============================================	

# Called when the node enters the scene tree for the first time.
func _ready():
	HandleFrontendShown(true)
	$Character.endGame.connect(_on_game_over_retry_map)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !isInFrontend:
		var MinimalPathNeeded = CurrentLevelMap.GetMinimalPathAmount($Character.get_position());
	
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
	$GameOver.ShowwGameOverMenu(false)
	$HUD.ShowwInGameHUD(!inState)
	isInFrontend = inState
	isGameOver = false
	isPaused = false
	
	if (isInFrontend):
		$Character.hide()
		$Character.SetMovementState(false)
	else:
		$Character.show()
		$Character.SetMovementState(true)

func HandlePauseState(InState : bool):
	isPaused = InState
	$HUD.ShowwPauseMenu(isPaused)
	$Character.SetMovementState(!InState)
	
func HandleGameOverState(InState : bool):
	isGameOver = InState
	$GameOver.ShowwGameOverMenu(isGameOver)
	$Character.ResourceManagement()
	$Character.SetMovementState(!InState)

func OnGraveHit(IsEntered : bool, InWriting : String):
	$HUD.ShowGraveWriting(true, InWriting)

func GetLevelToUse():
	return LevelLayouts

func ResetMap():
	$Character.setStartPos(CurrentLevelMap.CharacterStartLocation)
	$Character.alive = true
	var desired_children = []
	desired_children = get_tree().get_nodes_in_group("Energy")
	
	for child in desired_children:
		remove_child(child)

func SetMapLive(InNumber : int):
	
	if CurrentLevelMap:
		remove_child(CurrentLevelMap)
	
	var LevelFile = LevelLayouts[InNumber]
	
	CurrentLevelMap = LevelGenerateScene.instantiate()
	CurrentLevelMap.InitMap(LevelFile)
	CurrentLevelMap.set_position(Vector2i(16, 16))
		
	add_child(CurrentLevelMap)
	
	CurrentLevelMap.UpdateAllGraveTexts()

#=============================================
# Signals
#=============================================	

func _on_frontend_start_game():
	CurrentMapIndex = 1
	SetMapLive(CurrentMapIndex)
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
	$Character.ResourceManagement()
	HandlePauseState(false)
	pass # Replace with function body.


func _on_hud_on_resume_pressed():
	HandlePauseState(false)
	pass # Replace with function body.


func _on_game_over_next_map():
	CurrentMapIndex += 1
	SetMapLive(CurrentMapIndex)
	ResetMap()
	HandleGameOverState(false)
	pass # Replace with function body.


func _on_game_over_quit_map():
	HandleFrontendShown(true)
	pass # Replace with function body.


func _on_game_over_retry_map():
	ResetMap()
	$Character.ResourceManagement()
	HandleGameOverState(false)
	pass # Replace with function body.

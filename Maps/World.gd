extends Node

var isInFrontend : bool = true
var isPaused : bool = false
var isGameOver : bool = false
var CurrentMapIndex : int = 0

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
	$Character.endGame.connect(_on_hud_on_restart_pressed)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !isInFrontend:
		var MinimalPathNeeded = CurrentLevelMap.GetMinimalPathAmount($Character.get_position());
	
		$HUD.update_debugtext(MinimalPathNeeded)
		$Character.UpdateCellNeededToMove(MinimalPathNeeded)
	
		if  !isGameOver :
			if Input.is_action_just_pressed("Pause"):
				HandlePauseState(!isPaused)
	elif  !isGameOver:
		if Input.is_action_just_pressed("Pause"):
			get_tree().quit()

#=============================================
# General
#=============================================	

func HandleFrontendShown(inState : bool):
	$Frontend.ShowFrontend(inState)
	$HUD.ShowwPauseMenu(false)
	$GameOver.ShowwGameOverMenu(false)
	isInFrontend = inState
	isGameOver = false
	isPaused = false
	
	if (isInFrontend):
		$Character.hide()
		$Character.SetMovementState(false)
	else:
		HandleObjectiveShownState(true)

func HandlePauseState(InState : bool):
	isPaused = InState
	$HUD.ShowwPauseMenu(isPaused)
	$Character.SetMovementState(!InState)
	
func HandleGameOverState(InState : bool):
	isGameOver = InState
	$GameOver.ShowwGameOverMenu(isGameOver)
	$HUD.ShowwInGameHUD(false)
	$Character.ResourceManagement()
	$Character.SetMovementState(!InState)
	
func HandleObjectiveShownState(InState : bool):
	isGameOver = InState
	$HUD.ShowwInGameHUD(!InState)
	HandlePauseState(false)
	$Objective.ShowObjectiveScreen(InState, CurrentLevelMap.CurrentGraveToFind)
	$Character.SetMovementState(!InState)
	$Character.show()
	
	#print(CurrentLevelMap.CurrentGraveToFind.GraveName)
	#print(CurrentLevelMap.CurrentGraveToFind.GraveRiddle)
	#print(CurrentLevelMap.CurrentGraveToFind.GraveStone)
	

func OnGraveHit(IsEntered : bool, InWriting : String):
	$HUD.ShowGraveWriting(true, InWriting)
	await get_tree().create_timer(5).timeout
	$HUD.ShowGraveWriting(false, InWriting)
	
func OnGraveDug(GraveDug):
	if CurrentLevelMap.CurrentGraveToFind == GraveDug:
		GraveDug.DigHole(true)
		$Character.SetMovementState(false)
		$Character.End_Vignette()
		$HUD
		await get_tree().create_timer(2).timeout
		CurrentMapIndex += 1
		SetMapLive(CurrentMapIndex)
		ResetMap()
		HandleObjectiveShownState(true)
	else:
		GraveDug.DigHole(false)

func GetLevelToUse():
	return LevelLayouts

func ResetMap():
	$Character.setStartPos(CurrentLevelMap.CharacterStartLocation)
	$Character.alive = true
	$HUD.ShowGraveWriting(false, "")
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


func _on_objective_start_level():
	$Character.ResourceManagement()
	ResetMap()
	HandleObjectiveShownState(false)
	
	pass # Replace with function body.

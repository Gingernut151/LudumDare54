extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var MinimalPathNeeded = $Level_01.GetMinimalPathAmount($Character.get_position());
	
	$HUD.update_debugtext(MinimalPathNeeded)
	$Character.UpdateCellNeededToMove(MinimalPathNeeded)
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

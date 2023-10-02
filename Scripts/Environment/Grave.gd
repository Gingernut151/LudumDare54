extends Area2D

var GraveName : String
var GraveRiddle : PackedStringArray
var GraveStone : String

var inArea : bool = false

signal GraveDug

@onready var interaction_area: InteractionArea = $interaction_area

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.interact_dig = Callable(self, "_on_interact_Dig")
	$Grave_Empty.hide()
	$Grave_Hole.hide()

 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	if inArea && Input.is_action_pressed("Interact"):
#		var OwnerNode = get_node("/root/World")
#		OwnerNode.HandleGameOverState(true)	

func SetGraveWritting(InGraveName, InGraveRiddle, InGraveStone):
	GraveName = InGraveName
	GraveRiddle = InGraveRiddle
	GraveStone = InGraveStone
	
func GetNameOnGrave():
	return GraveName

func _on_interact():
	var OwnerNode = get_node("/root/World")
	OwnerNode.OnGraveHit(true, GraveStone)
	print("Grave Read")
	
func _on_interact_Dig():
	var OwnerNode = get_node("/root/World")
	OwnerNode.OnGraveDug(self)
	print("Grave Dug")
	
func DigHole(IsGoal : bool):
	if IsGoal:
		$Sprite2D.hide()
		$Grave_Empty.hide()
		$Grave_Hole.show()
	else:
		$Sprite2D.hide()
		$Grave_Empty.show()
		$Grave_Hole.hide()

#func _on_area_entered(area):
#	var OwnerNode = get_node("/root/World")
#	
#	if OwnerNode:
#		OwnerNode.OnGraveDug(self)
#	inArea = true
#	print("in Grave")
#
#func _on_area_exited(area):
#	inArea = false
#	print("Out Grave")

#func _on_input_event(viewport, event, shape_idx):
#	var OwnerNode = get_node("/root/World")
#	OwnerNode.HandleGameOverState(true)	
#	pass # Replace with function body.

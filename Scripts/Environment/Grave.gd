extends Area2D

var GraveWriting : String = ""

var inArea : bool = false

@onready var interaction_area: InteractionArea = $interaction_area

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	if inArea && Input.is_action_pressed("Interact"):
#		var OwnerNode = get_node("/root/World")
#		OwnerNode.HandleGameOverState(true)	

func SetGraveWritting(InWritting):
	GraveWriting = InWritting

func _on_interact():
	var OwnerNode = get_node("/root/World")
	OwnerNode.OnGraveHit(true, GraveWriting)
	print("hit")




#func _on_area_entered(area):
#	var OwnerNode = get_node("/root/World")
#	OwnerNode.OnGraveHit(true, GraveWriting)
#	inArea = true
#	print(inArea)
#
#func _on_area_exited(area):
#	var OwnerNode = get_node("/root/World")
#	OwnerNode.OnGraveHit(false, "")
#	inArea = false
#	print(inArea)

#func _on_input_event(viewport, event, shape_idx):
#	var OwnerNode = get_node("/root/World")
#	OwnerNode.HandleGameOverState(true)	
#	pass # Replace with function body.

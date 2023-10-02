extends Control

var Grave

signal StartLevel

#=============================================
# Pre deifned
#=============================================	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#=============================================
# General
#=============================================	

func ShowObjectiveScreen(ShouldShow : bool, InGrave):
	Grave = InGrave
	
	if ShouldShow:
		$CanvasLayer/btn_Resume.grab_focus()
		$CanvasLayer.show()
		$CanvasLayer/Label.text = "
		The clue to unveil, 
		the tomb to invade,
		Lies within the riddle, 
		in words we've laid.
		 "
		
		for line in InGrave.GraveRiddle:
			var NewLine = Label.new()
			NewLine.text = line
			NewLine.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			NewLine.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			#NewLine.theme = "res://UI/new_theme.tres"
			$CanvasLayer/VBoxContainer.add_child(NewLine)
		
		
	else:
		$CanvasLayer.hide()
		
		for child in $CanvasLayer/VBoxContainer.get_children():
			$CanvasLayer/VBoxContainer.remove_child(child)

#=============================================
# Signal
#=============================================	

func _on_btn_resume_pressed():
	StartLevel.emit()

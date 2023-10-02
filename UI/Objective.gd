extends Control

var Grave_Name : String

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

func ShowObjectiveScreen(ShouldShow : bool, InName : String):
	Grave_Name = InName
	
	if ShouldShow:
		$CanvasLayer/btn_Resume.grab_focus()
		$CanvasLayer.show()
		$CanvasLayer/Label.text = "The Grave to Raid is: 
			" + Grave_Name
	else:
		$CanvasLayer.hide()

#=============================================
# Signal
#=============================================	

func _on_btn_resume_pressed():
	StartLevel.emit()

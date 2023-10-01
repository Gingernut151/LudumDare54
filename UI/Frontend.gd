extends Control

signal Start_Game
signal Quit_Game

#=============================================
# Pre Defined
#=============================================	

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/AnimatedSprite2D.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ShowFrontend(InState : bool):
	
	if InState:
		$CanvasLayer.show()
		$MenuMusic.play()
		$MenuMusic/AnimationPlayer.play_backwards("MenuMusic")
	else:
		$CanvasLayer.hide()
		$MenuMusic/AnimationPlayer.play("MenuMusic")
		if !$MenuMusic/AnimationPlayer.is_playing():
			$MenuMusic.stop()

#=============================================
# Signals
#=============================================	

func _on_btn_start_game_pressed():
	Start_Game.emit()
	pass # Replace with function body.s


func _on_btn_quit_game_pressed():
	Quit_Game.emit()
	pass # Replace with function body.

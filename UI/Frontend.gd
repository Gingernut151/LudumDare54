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
		$CanvasLayer/btn_StartGame.grab_focus()
	else:
		$CanvasLayer.hide()
		$MenuMusic/AnimationPlayer.play("MenuMusic")
		$MenuMusic/AnimationPlayer.connect("animation_finished", On_Anim_Finished)

func On_Anim_Finished(anim_name):
	if anim_name == "MenuMusic":
		$MenuMusic.stop()
		$MenuMusic/AnimationPlayer.disconnect("animation_finished", On_Anim_Finished)

#=============================================
# Signals
#=============================================	

func _on_btn_start_game_pressed():
	Start_Game.emit()
	pass # Replace with function body.s


func _on_btn_quit_game_pressed():
	Quit_Game.emit()
	pass # Replace with function body.

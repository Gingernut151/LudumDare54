extends CharacterBody2D

@export var speed: int = 200
var CharacterWidth: float = 50.0
var CharacterHeight: float = 100.0

var CurrentAmountToMove: float = -1.0
var CurrentMoveVector: Vector2

@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	handleInput(delta)
	move_and_slide()


func handleInput(delta):
	var moveDirection = GetInputDirectionPressed()
	
	if moveDirection != Vector2.ZERO:
		if CurrentAmountToMove <= 0.0:
			CurrentAmountToMove = 50.0
			CurrentMoveVector = moveDirection
			
			
	if CurrentAmountToMove > 0.0:
		velocity = CurrentMoveVector * speed
		CurrentAmountToMove -= velocity.length() * delta
	else:
		velocity = Vector2.ZERO

func GetInputDirectionPressed():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_pressed("ui_right"):
		_animated_sprite.play("walk")
		_animated_sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		_animated_sprite.play("walk")
		_animated_sprite.flip_h = true
	else:
		_animated_sprite.play("idle")
	
	if (abs(moveDirection.length()) != 1.0):
		moveDirection = Vector2.ZERO
	
	return moveDirection

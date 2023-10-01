extends Area2D

var animation_speed = 2
var moving = false
var tile_size = 40
var CellsNeededToComplete : int = 0
var StanimaVignetePower : float = 0.33
var CanMove : bool = false

	
var lastPos:= Vector2()
@export var posOffset:= Vector2()
var Energy = preload("res://Scripts/Environment/Energy.tscn")

@onready var shader_value = $Camera2D/Shader.material.get_shader_parameter("vignette_opacity")
@onready var ray = $RayCast2D
@onready var _animated_sprite = $AnimatedSprite2D
@onready var pickedUp

var inputs = {
	"Movement_Right": Vector2.RIGHT,
	"Movement_Left": Vector2.LEFT,
	"Movement_Up": Vector2.UP,
	"Movement_Down": Vector2.DOWN
}

#=============================================
# Pre Defined
#=============================================	

func _ready():
	pickedUp = false
	lastPos = self.position
	pass

#=============================================
# Input
#=============================================	

func _unhandled_input(event):
	if moving || !CanMove:
		return
	
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func GetInputDirectionPressed(dir):
	if inputs[dir] == inputs.Movement_Right:
		_animated_sprite.play("walk")
		_animated_sprite.flip_h = false
		_animated_sprite.rotation_degrees = 0.0
		
	elif inputs[dir] == inputs.Movement_Left:
		_animated_sprite.play("walk")
		_animated_sprite.flip_h = true
		_animated_sprite.rotation_degrees = 0.0
		
	elif inputs[dir] == inputs.Movement_Up:
		_animated_sprite.play("walk")
		
	elif inputs[dir] == inputs.Movement_Down:
		_animated_sprite.play("walk")
		
	else:
		_animated_sprite.play("idle")

func SetMovementState(InState : bool):
	CanMove = InState;

#=============================================
# Movement
#=============================================	

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		lastPos = self.position
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		#$AnimationPlayer.play(dir)
		GetInputDirectionPressed(dir)
		await tween.finished
		moving = false
		_animated_sprite.play("idle")
		SpawnEnergy()

func setStartPos(InPosition : Vector2):
	position = InPosition
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	_animated_sprite.play("idle")
	shader_value = 0.033
	

#=============================================
# Abilities
#=============================================	

func ResourceManagement():
	shader_value += (StanimaVignetePower / CellsNeededToComplete)
	print(shader_value)
	$Camera2D/Shader.material.set_shader_parameter("vignette_opacity", shader_value)
	$Camera2D/Shader.material.set_shader_parameter("vignette_opacity", shader_value)

	
func SpawnEnergy():
	$Footsteps.play()
	if pickedUp == false:
		var instance = Energy.instantiate()
		instance.add_to_group("Energy")
		get_tree().get_root().get_node("World").add_child(instance)	
		instance.position = (lastPos + posOffset)
		ResourceManagement()
	
	pickedUp = false
	

func _on_area_entered(area):
	get_tree().get_root().get_node("World").remove_child(area)
	shader_value -= (StanimaVignetePower / CellsNeededToComplete)
	print(shader_value)
	$Camera2D/Shader.material.set_shader_parameter("vignette_opacity", shader_value)
	pickedUp = true

#=============================================
# UI
#=============================================	

func UpdateCellNeededToMove(CellCount):
	if CellsNeededToComplete == 0:
		CellsNeededToComplete = CellCount

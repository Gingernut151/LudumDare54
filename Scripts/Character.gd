extends Area2D

var animation_speed = 2
var moving = false
var tile_size = 40
var inputs = {
	"Movement_Right": Vector2.RIGHT,
	"Movement_Left": Vector2.LEFT,
	"Movement_Up": Vector2.UP,
	"Movement_Down": Vector2.DOWN
}

@onready var ray = $RayCast2D
@onready var _animated_sprite = $AnimatedSprite2D

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


func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	_animated_sprite.play("idle")
	
func _unhandled_input(event):
	if moving:
		return
	
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
			
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		#$AnimationPlayer.play(dir)
		GetInputDirectionPressed(dir)
		await tween.finished
		moving = false
		_animated_sprite.play("idle")

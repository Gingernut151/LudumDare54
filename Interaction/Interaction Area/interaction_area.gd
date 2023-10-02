extends Area2D
class_name InteractionArea

@export var action_name: String = "Interact"


var interact: Callable = func():
	pass
	

func _on_area_entered(area: Area2D) -> void:
	InteractionManager.register_area(self)




func _on_area_exited(area: Area2D) -> void:
	InteractionManager.unregister_area(self)

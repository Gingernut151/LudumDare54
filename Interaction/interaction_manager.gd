extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var label = $Label


const base_text = "[E] or (A) to "
const Dig_text = "[R] or (X) to "

var active_areas = []
@export var can_interact = true


func register_area(area: InteractionArea):
		active_areas.push_back(area)


func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
	



func _process(delta):
	if active_areas.size() > 0 && can_interact && player.CanMove:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		$Label_Dig.text = Dig_text + active_areas[0].Dig_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 50
		label.global_position.x -= label.size.x / 2 - 12
		$Label_Dig.global_position = label.global_position
		$Label_Dig.global_position.y += 26
		label.show()
		$Label_Dig.show()
	else:
		label.hide()
		$Label_Dig.hide()
		
		
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func _input(event):
	if event.is_action_pressed("Interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			$Label_Dig.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
			
	if event.is_action_pressed("Dig") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			$Label_Dig.hide()
			
			await active_areas[0].interact_dig.call()
			
			can_interact = true

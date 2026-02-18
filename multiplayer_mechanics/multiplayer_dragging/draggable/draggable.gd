class_name Draggable extends AnimatableBody2D


static var instances: Array[Draggable]

var dragged: Cursor:
	get:
		return dragged
	set(value):
		dragged = value
		if dragged:
			set_collision_layer_value(1, false)
			set_collision_mask_value(1, false)
			# When picked up, turn off layer 1 and mask 1
		
		else:
			set_collision_layer_value(1, true)
			set_collision_mask_value(1, true)


func _enter_tree() -> void:
	instances.append(self)


func _exit_tree() -> void:
	var index: int = instances.find(self)
	if index >= 0:
		instances.remove_at(index)

@tool
class_name PickupComponent extends Node


var cursor_offset: Cursor
@export var pickup_area: Area2D:
	set(value):
		pickup_area = value
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if not pickup_area: 
		warnings.append("PickupComponent requires an Area2D for cursor interaction.")
	return warnings
func _process(delta: float) -> void:
	pass


func _ready() -> void: 
	pickup_area.area_entered.connect(_on_area_entered)
	pickup_area.area_exited.connect(_on_area_exited)

func _exit_tree() -> void:
	pickup_area.area_entered.disconnect(_on_area_entered)
	pickup_area.area_exited.disconnect(_on_area_exited)


func _on_area_entered(other: Node) -> void:
	var cursor: Cursor = other.get_parent() as Cursor
	if not Cursor:
		return
	cursor.interaction_started.connect(_on_cursor_interaction_started)
	cursor.interaction_stopped.connect(_on_cursor_interaction_stopped)

func _on_area_exited(other: Node) -> void:
	var cursor: Cursor = other.get_parent() as Cursor
	if not Cursor:
		return
	cursor.interaction_started.disconnect(_on_cursor_interaction_started)
	cursor.interaction_stopped.disconnect(_on_cursor_interaction_stopped)


func _on_cursor_interaction_started(cursor: Cursor) -> void: 
	pass

func _on_cursor_interaction_stopped(cursor: Cursor) -> void: 
	pass

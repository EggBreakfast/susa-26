@tool
class_name PickupComponent extends Node


signal grabbed(node: Node)
signal dropped(node: Node)

var cursor_offset: Vector2
var current_cursor: Cursor ## The cursor that is currently holding the ingredient.

@export var entity: Node
@export var pickup_area: Area2D:
	set(value):
		pickup_area = value
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if not pickup_area: 
		warnings.append("PickupComponent requires an Area2D for cursor interaction.")
	return warnings


func _ready() -> void: 
	pickup_area.area_entered.connect(_on_area_entered)
	pickup_area.area_exited.connect(_on_area_exited)

func _exit_tree() -> void:
	pickup_area.area_entered.disconnect(_on_area_entered)
	pickup_area.area_exited.disconnect(_on_area_exited)


func _on_area_entered(other: Node) -> void:
	var cursor: Cursor = other.get_parent() as Cursor
	if not cursor:
		return
	cursor.interaction_started.connect(_on_cursor_interaction_started)
	cursor.interaction_stopped.connect(_on_cursor_interaction_stopped)

func _on_area_exited(other: Node) -> void:
	var cursor: Cursor = other.get_parent() as Cursor
	if not cursor:
		return
	cursor.interaction_started.disconnect(_on_cursor_interaction_started)
	cursor.interaction_stopped.disconnect(_on_cursor_interaction_stopped)


func _on_cursor_interaction_started(cursor: Cursor) -> void: 
	if current_cursor:
		return
	
	current_cursor = cursor
	cursor_offset = current_cursor.global_position - get_parent().global_position
	grabbed.emit(self)

@warning_ignore_start("unused_parameter")
func _on_cursor_interaction_stopped(cursor: Cursor) -> void: 
	current_cursor = null
	dropped.emit(self)


func _process(delta: float) -> void:
	if current_cursor:
		entity.global_position = current_cursor.global_position + cursor_offset

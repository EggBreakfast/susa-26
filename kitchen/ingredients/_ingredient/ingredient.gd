class_name Ingredient
extends AnimatableBody2D


@export var area: Area2D


## The cursor that is crrently holding the ingredient
var current_cursor: Cursor
var cursor_offset: Vector2

func _ready() -> void:
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)


func _exit_tree() -> void:
	area.area_entered.disconnect(_on_area_entered)
	area.area_exited.disconnect(_on_area_exited)


func _on_area_entered(other: Area2D) -> void:
	if other.get_parent() is not Cursor:
		return
	
	var cursor: Cursor = other.get_parent()
	cursor.interaction_started.connect(_on_cursor_interaction_started)
	cursor.interaction_stopped.connect(_on_cursor_interaction_stopped)


func _on_area_exited(other: Area2D) -> void:
	if other.get_parent() is not Cursor:
		return
	
	var cursor: Cursor = other.get_parent()
	cursor.interaction_started.disconnect(_on_cursor_interaction_started)
	cursor.interaction_stopped.disconnect(_on_cursor_interaction_stopped)


@warning_ignore ("unused_parameter")
func _process(delta: float) -> void:
	if current_cursor:
		global_position = current_cursor.global_position + cursor_offset


func _on_cursor_interaction_started(cursor: Cursor) -> void:
	current_cursor = cursor
	cursor_offset = global_position - current_cursor.global_position
	print_debug(cursor, ":: Interaction started!")

func _on_cursor_interaction_stopped(cursor: Cursor) -> void:
	if current_cursor == cursor:
		current_cursor = null #Player 2 can no longer steal items from Player 1
	print_debug(cursor, ":: Interaction stopped,,,")

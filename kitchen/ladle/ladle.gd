class_name Ladle extends Node2D

@export var pickup_area: Area2D
@export var slop_area: Area2D
@export var sprite_slop: Sprite2D

signal grabbed(ladle: Ladle)
signal dropped(ladle: Ladle)
signal slopped(ladle: Ladle)

var current_cursor: Cursor
var cursor_offset: Vector2

var ladle_filled: bool = false


func _ready() -> void:
	pickup_area.area_entered.connect(_on_pickup_area_entered)
	pickup_area.area_exited.connect(_on_pickup_area_exited)
	
	slop_area.area_entered.connect(_on_slop_area_entered)
	slop_area.area_exited.connect(_on_slop_area_exited)

func _exit_tree() -> void:
	pickup_area.area_entered.disconnect(_on_pickup_area_entered)
	pickup_area.area_exited.disconnect(_on_pickup_area_exited)
	
	slop_area.area_entered.disconnect(_on_slop_area_entered)
	slop_area.area_exited.disconnect(_on_slop_area_exited)


func _on_pickup_area_entered(other: Area2D) -> void:
	if other.get_parent() is not Cursor:
		return
	
	var cursor: Cursor = other.get_parent()
	cursor.interaction_started.connect(_on_cursor_interaction_started)
	cursor.interaction_stopped.connect(_on_cursor_interaction_stopped)

func _on_pickup_area_exited(other: Area2D) -> void:
	if other.get_parent() is not Cursor:
		return
	
	var cursor: Cursor = other.get_parent()
	cursor.interaction_started.disconnect(_on_cursor_interaction_started)
	cursor.interaction_stopped.disconnect(_on_cursor_interaction_stopped)

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if current_cursor:
		global_position = current_cursor.global_position + cursor_offset

func _on_cursor_interaction_started(cursor: Cursor) -> void:
	current_cursor = cursor
	cursor_offset = global_position - current_cursor.global_position
	grabbed.emit(self)

func _on_cursor_interaction_stopped(cursor: Cursor) -> void:
	if current_cursor == cursor:
		current_cursor = null 
	dropped.emit(self)


func _on_slop_area_entered(other: Area2D) -> void:
	if other.get_parent() is not Pot:
		return
	
	var pot: Pot = other.get_parent()
	ladle_filled = true
	sprite_slop.modulate.r = pot.color_shift.x
	sprite_slop.modulate.g = pot.color_shift.y
	sprite_slop.modulate.b = pot.color_shift.z
	sprite_slop.modulate.a = 
	

func _on_slop_area_exited(other: Area2D) -> void:
	if other.get_parent() is not Pot:
		return
	
	

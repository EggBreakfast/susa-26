class_name Ingredient
extends AnimatableBody2D

signal grabbed(ingredient: Ingredient)
signal dropped(ingredient: Ingredient)

@export var data: IngredientData

@export_group("Node References")
@export var area: Area2D
@export var sprite: Sprite2D

var prep_percentage: float = 0.0

var is_raw: bool:
	get:
		return prep_percentage < 1.0
var is_prepped: bool:
	get:
		return prep_percentage >= 1.0 and prep_percentage < data.overprep_percentage
	
var is_overprepped: bool:
	get:
		return prep_percentage >= data.overprep_percentage


## The cursor that is currently holding the ingredient
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
	
	if prep_percentage >= 1.0 and prep_percentage < data.overprep_percentage:
		sprite.texture = data.texture_prepped
		sprite.modulate = data.modulate_prepped
	
	if prep_percentage >= data.overprep_percentage:
		sprite.texture = data.texture_overprepped
		sprite.modulate = data.modulate_overprepped

func _on_cursor_interaction_started(cursor: Cursor) -> void:
	current_cursor = cursor
	cursor_offset = global_position - current_cursor.global_position
	grabbed.emit(self)

func _on_cursor_interaction_stopped(cursor: Cursor) -> void:
	if current_cursor == cursor:
		current_cursor = null #Player 2 can no longer steal items from Player 1
	dropped.emit(self)

class_name Bowl extends Node2D

signal grabbed(bowl: Bowl)
signal dropped(bowl: Bowl)

@export var sprite_slop: Sprite2D
@export var area: Area2D


var bowl_filled: bool = false
var ingredients: Array[Ingredient]

var current_cursor: Cursor
var cursor_offset: Vector2


func _ready() -> void:
	SignalHolder.bowl_delivered_to_customer.connect(_on_bowl_delivered)
	
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)


func _exit_tree() -> void:
	SignalHolder.bowl_delivered_to_customer.disconnect(_on_bowl_delivered)
	
	area.area_entered.disconnect(_on_area_entered)
	area.area_exited.disconnect(_on_area_exited)


func _on_area_entered(other: Node) -> void:
	var parent: Node = other.get_parent()
	if parent is Cursor:
		return _on_cursor_entered(parent)
	
	if parent is Ladle and parent.ladle_filled and other == parent.slop_area:
		return _on_ladle_entered(parent)


func _on_area_exited(other: Area2D) -> void:
	var cursor: Cursor = other.get_parent() as Cursor
	if cursor: 
		_on_cursor_exited(cursor)
	

func _on_cursor_entered(cursor: Cursor) -> void:
	cursor.interaction_started.connect(_on_cursor_interaction_started)
	cursor.interaction_stopped.connect(_on_cursor_interaction_stopped)

func _on_cursor_exited(cursor: Cursor) -> void:
	cursor.interaction_started.disconnect(_on_cursor_interaction_started)
	cursor.interaction_stopped.disconnect(_on_cursor_interaction_stopped)

func _on_ladle_entered(ladle: Ladle) -> void: 
	# transfer contents to bowl
	bowl_filled = true
	sprite_slop.modulate = ladle.sprite_slop.modulate
	ingredients = ladle.ingredients
	
	# clear out ladle's contents!
	ladle.ladle_filled = false
	ladle.sprite_slop.modulate = Color.TRANSPARENT
	ladle.ingredients = []


func _on_bowl_delivered(bowl: Bowl) -> void:
	if bowl != self: 
		return
	
	await get_tree().process_frame
	ingredients = []
	bowl_filled = false


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

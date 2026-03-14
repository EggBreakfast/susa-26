extends Node2D

@onready var lines: Node2D = $Lines

@export var color: Color = Color()
@export var radius := 5
@export var area: Area2D

var is_pressed: bool = false
#var current_line: Line2D 
var cursor_lines: Dictionary [Cursor, Line2D] #[Key, Value]
var mouse_position := Vector2.ZERO
var undone_lines: Array [Line2D]
var active_cursors: Array[Cursor]


func _ready()-> void:
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)

func _on_area_entered(other: Area2D) -> void:
	if other.get_parent() is not Cursor:
		return
	
	var cursor: Cursor = other.get_parent()
	#active_cursors.append(cursor)
	
	cursor.interaction_started.connect(_on_cursor_interaction_started)
	cursor.interaction_stopped.connect(_on_cursor_interaction_stopped)

func _on_area_exited(other: Area2D) -> void:
	if other.get_parent() is not Cursor:
		return
	
	var cursor: Cursor = other.get_parent()
	_on_cursor_interaction_stopped(cursor)
	
	#var index: int = active_cursors.find(other.get_parent())
	#if index >= 0:
		#active_cursors.remove_at(index)
	
	cursor.interaction_started.disconnect(_on_cursor_interaction_started)
	cursor.interaction_stopped.disconnect(_on_cursor_interaction_stopped)

func _on_cursor_interaction_started (cursor: Cursor) -> void:
	is_pressed = true
	active_cursors.append(cursor)
	
	var line: Line2D = Line2D.new()
	line.default_color = cursor.color
	line.width = radius
	line.antialiased = true

	lines.add_child(line)
	cursor_lines.set(cursor, line)


func _on_cursor_interaction_stopped (cursor: Cursor) -> void:
	is_pressed = false
	var index: int = active_cursors.find(cursor)
	if index >= 0:
		active_cursors.remove_at(index)
	pass


	

func _unhandled_input(event:InputEvent)-> void:
	#if event is InputEventMouseButton:
		#event = event as InputEventMouseButton
		##for the rest of this function, the game treats event as if it were InputEventMouseButton
		#
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#is_pressed = event.pressed
			#
			#if is_pressed:
				#current_line = Line2D.new()
				#lines.add_child(current_line)
				#current_line.default_color = color
				#current_line.width = radius
				#current_line.antialiased = true
				##for lines in undone_lines:
					##lines.queue_free()
				##For garbage collection
				#undone_lines.clear()
	
	if event is InputEventMouseMotion:
		mouse_position = event.global_position
	
	if event.is_action_pressed("Redo"):
		redo()
	if event.is_action_pressed("Undo") and not event.shift_pressed:
		undo()
	if event.is_action_pressed("Capture"):
		capture()
		#WIP capture; maybe change to some other event later


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if active_cursors.size() > 0:
		for active_cursor: Cursor in active_cursors:
			var line: Line2D = cursor_lines.get(active_cursor)
			line.add_point(active_cursor.global_position - global_position)
	
	#if is_pressed and mouse_position != Vector2.ZERO:
		#current_line.add_point(mouse_position)
		#mouse_position = Vector2.ZERO


func undo() -> void:
	if lines.get_child_count()<=0:
		return
		#if there are no children, don't do anything
	
	var line_to_delete:Line2D = lines.get_child(-1)
	#line_to_delete.queue_free()
	#this deletes it entirely
	lines.remove_child(line_to_delete)
	undone_lines.append(line_to_delete)
	


func redo() -> void:
	if undone_lines.size()<=0:
		return
	
	var line_redone := undone_lines.pop_at(-1) as Line2D
	print_debug(line_redone)
	lines.add_child(line_redone)
	


func capture() -> void:
	var image := get_viewport().get_texture().get_image()
	var screen_size = DisplayServer.screen_get_size()
	var order_sprite := Sprite2D.new()
	add_child(order_sprite)
	order_sprite.texture = ImageTexture.create_from_image(image)
	order_sprite.scale /= 2
	order_sprite.position = Vector2(screen_size)/3.5
	
	
	
	
# Splat me now
# References: https://www.youtube.com/watch?v=2EkoIB0c8Rw, https://www.youtube.com/watch?v=U_TGOgp5-pc, https://www.youtube.com/watch?v=zvWA4vMPoLI

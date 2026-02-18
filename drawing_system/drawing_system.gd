extends Node2D

@onready var lines: Node2D = $Lines

@export var color: Color = Color()
@export var radius := 5

var is_pressed: bool = false
var current_line: Line2D 
var mouse_position := Vector2.ZERO
var undone_lines: Array [Line2D]

func _unhandled_input(event:InputEvent)-> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		#for the rest of this function, the game treats event as if it were InputEventMouseButton
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_pressed = event.pressed
			
			if is_pressed:
				current_line = Line2D.new()
				lines.add_child(current_line)
				current_line.default_color = color
				current_line.width = radius
				current_line.antialiased = true
				#for lines in undone_lines:
					#lines.queue_free()
				#For garbage collection
				undone_lines.clear()
	
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
	if is_pressed and mouse_position != Vector2.ZERO:
		current_line.add_point(mouse_position)
		mouse_position = Vector2.ZERO


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

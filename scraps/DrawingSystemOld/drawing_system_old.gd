extends Node2D

var circle_position:Array[Vector2]
#var button_press : InputEvent

func _ready() -> void:
	_draw()

func _draw():
	for i in range(1, len(circle_position)):
		var circle_a := circle_position[i]
		
		if i < len(circle_position)-1:
			var circle_b := circle_position[i+1]
			var bline = Geometry2D.bresenham_line(circle_a, circle_b)
			for point in bline:
				draw_circle(point, 7, Color(0.0, 0.0, 0.0, 1.0))

func _input(button_press: InputEvent) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
		
	else :
		circle_position.append(button_press.position)
		queue_redraw()


		#for point in circle_position.bresenham_line($MarkerA.position, $MarkerB.position):
			#draw_circle(point,7,Color.BLACK) 

#func _process(delta: float) -> void:
	#return

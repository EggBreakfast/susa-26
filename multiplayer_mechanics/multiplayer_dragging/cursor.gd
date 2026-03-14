class_name Cursor extends Control


signal interaction_started
signal interaction_stopped


@export var id: StringName = &"p1"

@export var movement_speed: float = 640.0

@export var color: Color

@onready var input_up: StringName = &"%s_move_forward" % id
@onready var input_down: StringName = &"%s_move_backward" % id
@onready var input_left: StringName = &"%s_move_left" % id
@onready var input_right: StringName = &"%s_move_right" % id
@onready var input_grab: StringName = &"%s_grab" % id
@onready var input_interact: StringName = &"%s_cursor_interact" % id

var is_grabbing: bool = false
var max_grab_distance: float = 320.0
var draggable: Draggable

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(input_interact):
		interaction_started.emit(self)
	
	if event.is_action_released(input_interact):
		interaction_stopped.emit(self)
	
	
	if event.is_action_pressed(input_grab): 
		# THIS IS FOR TOGGLE !
		#if is_grabbing and draggable != null:
			#is_grabbing = false
			#draggable = null 
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
		query.position = global_position
		query.collide_with_bodies = true
		#query.collision_mask = your_mask
		var result: Array[Dictionary] = space_state.intersect_point(query)
		if result.size() > 0:
			var collider: Node2D = result[0].collider
			if collider is Draggable and not collider.dragged: 
				is_grabbing = true
				draggable = collider
				draggable.dragged = self
	
	if event.is_action_released(input_grab):
		is_grabbing = false
		if draggable:
			draggable.dragged = null
		draggable = null

func _physics_process(delta: float) -> void:
	var movement_input: Vector2 = Input.get_vector(input_left, input_right, input_up, input_down)
	
	position += movement_input * movement_speed * delta
	
	var viewport_rect: Rect2 = get_viewport_rect()
	position.x = clampf(position.x, 0.0, viewport_rect.end.x - size.x)
	position.y = clampf(position.y, 0.0, viewport_rect.end.y - size.x)
	
	if is_grabbing and draggable != null:
		draggable.global_position = global_position

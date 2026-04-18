class_name Cursor extends Control


signal interaction_started(cursor: Cursor, node: Node)
signal interaction_stopped(ucrsor: Cursor, node: Node)


@export var id: StringName = &"p1"
@export var movement_speed: float = 640.0
@export var color: Color
@export var screen_peek: float = 4.0

@onready var input_up: StringName = &"%s_move_forward" % id
@onready var input_down: StringName = &"%s_move_backward" % id
@onready var input_left: StringName = &"%s_move_left" % id
@onready var input_right: StringName = &"%s_move_right" % id
@onready var input_grab: StringName = &"%s_grab" % id
@onready var input_interact: StringName = &"%s_cursor_interact" % id

@export_group("Node References")
@export var area: Area2D
@export var hit_area: Marker2D

@export var cursor_sprite: AnimatedSprite2D


var is_grabbing: bool = false
var max_grab_distance: float = 320.0
var draggable: Draggable
var entered_button_area: bool = false


func _ready() -> void:
	SignalBroker.cursor_spawned.emit(self)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(input_interact) or event.is_action_released(input_interact):
		for canvas_layer: CanvasLayer in Helpers.find_nodes_of_type(get_tree().root, CanvasLayer):
			if canvas_layer.name == "MainScreen":
				var node: Node = Helpers.get_node_at_position(hit_area.global_position, canvas_layer.get_instance_id())
				if event.is_action_pressed(input_interact):
					interaction_started.emit(self, node)
				else:
					interaction_stopped.emit(self, node)
	
	
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
				cursor_sprite.play(&"grab")
				draggable = collider
				draggable.dragged = self
	
	if event.is_action_released(input_grab):
		is_grabbing = false
		if draggable:
			draggable.dragged = null
		draggable = null
		cursor_sprite.play(&"idle")

func _physics_process(delta: float) -> void:
	var movement_input: Vector2 = Input.get_vector(input_left, input_right, input_up, input_down)
	
	position += movement_input * movement_speed * delta
	
	var viewport_rect: Rect2 = get_viewport_rect()
	position.x = clampf(position.x, 0.0, viewport_rect.end.x - screen_peek)
	position.y = clampf(position.y, 0.0, viewport_rect.end.y - screen_peek)
	
	if is_grabbing and draggable != null:
		draggable.global_position = global_position
	

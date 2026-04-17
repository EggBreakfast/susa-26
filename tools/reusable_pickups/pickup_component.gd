@tool
class_name PickupComponent extends Node


signal grabbed(node: Node)
signal dropped(node: Node)


var cursor_offset: Vector2
var current_cursor: Cursor ## The cursor that is currently holding the ingredient.

@export var is_physics_based: bool = false:
	get:
		return is_physics_based #default: just return the value
	set(value):
		is_physics_based = value #value = whatever you were given
		update_configuration_warnings()
		

@export var entity: Node
@export var pickup_area: Area2D:
	get:
		return pickup_area
	set(value):
		pickup_area = value
		update_configuration_warnings()
@export var movement_speed: float = 640.0
@export var min_cursor_distance: float = 6.0


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if not pickup_area: 
		warnings.append("PickupComponent requires an Area2D for cursor interaction.")
	return warnings


func _ready() -> void: 
	if not Engine.is_editor_hint():
		pickup_area.area_entered.connect(_on_area_entered)
		pickup_area.area_exited.connect(_on_area_exited)

func _exit_tree() -> void:
	if not Engine.is_editor_hint():
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


func _on_cursor_interaction_started(cursor: Cursor, node: Node) -> void: 
	if current_cursor:
		return
	
	if node and (node == entity or node.get_parent() == entity):
		current_cursor = cursor
		cursor_offset = get_parent().global_position - current_cursor.global_position 
		grabbed.emit(entity)

@warning_ignore_start("unused_parameter")
func _on_cursor_interaction_stopped(cursor: Cursor, node: Node) -> void: 
	if current_cursor == cursor:
		current_cursor = null
		dropped.emit(entity)


func _process(delta: float) -> void:
	if current_cursor:
		if is_physics_based:
			var distance: Vector2 = (current_cursor.global_position + cursor_offset) - entity.global_position
			if distance.length() >= min_cursor_distance:
				var direction: Vector2 = entity.global_position.direction_to(current_cursor.global_position + cursor_offset)
				entity.velocity = direction * movement_speed
				entity.move_and_slide()
			else:
				entity.move_and_collide(distance * (movement_speed * 0.1) * delta)
		
		else:
			entity.global_position = current_cursor.global_position + cursor_offset
	#elif current_cursor:
		#physics_collision_area.move_and_collide(((current_cursor.global_position + cursor_offset) - entity.global_position) * 64.0 * delta)
		#move_and_collide(((current_cursor.global_position + cursor_offset) - entity.global_position) * 64.0 * delta)

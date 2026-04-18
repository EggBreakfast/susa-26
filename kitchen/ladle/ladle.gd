class_name Ladle extends CharacterBody2D

@export_group("Node References")
@export var pickup_area: Area2D
@export var slop_area: Area2D
@export var collision_area: CollisionPolygon2D
@export var sprite_slop: Sprite2D

@export_group("Movement Settings")
@export var movement_speed: float = 5.0
@export var min_cursor_distance: float = 8.0

signal grabbed(ladle: Ladle)
signal dropped(ladle: Ladle)

var current_cursor: Cursor
var cursor_offset: Vector2
var ingredients: Array[IngredientData]

var ladle_filled: bool = false


func _ready() -> void:
	#pickup_area.area_entered.connect(_on_pickup_area_entered)
	#pickup_area.area_exited.connect(_on_pickup_area_exited)
	#collision_area.area_entered.connect(_on_collision_area_entered)
	#collision_area.area_exited.connect(_on_collision_area_exited)
	
	slop_area.area_entered.connect(_on_slop_area_entered)
	slop_area.area_exited.connect(_on_slop_area_exited)

func _exit_tree() -> void:
	#pickup_area.area_entered.disconnect(_on_pickup_area_entered)
	#pickup_area.area_exited.disconnect(_on_pickup_area_exited)
	#collision_area.area_entered.disconnect(_on_collision_area_entered)
	#collision_area.area_exited.disconnect(_on_collision_area_exited)
	
	slop_area.area_entered.disconnect(_on_slop_area_entered)
	slop_area.area_exited.disconnect(_on_slop_area_exited)


#func _on_pickup_area_entered(other: Area2D) -> void:
	#if other.get_parent() is not Cursor:
		#return
	
	#var cursor: Cursor = other.get_parent()
	#cursor.interaction_started.connect(_on_cursor_interaction_started)
	#cursor.interaction_stopped.connect(_on_cursor_interaction_stopped)

#func _on_pickup_area_exited(other: Area2D) -> void:
	#if other.get_parent() is not Cursor:
		#return
	#
	#var cursor: Cursor = other.get_parent()
	#cursor.interaction_started.disconnect(_on_cursor_interaction_started)
	#cursor.interaction_stopped.disconnect(_on_cursor_interaction_stopped)


func _physics_process(delta: float) -> void:
	if current_cursor:
		#Old system for RigidBody2D
		#move_and_collide((((current_cursor.global_position + cursor_offset) - global_position) * 64.0 * delta))
		var distance: Vector2 = (current_cursor.global_position + cursor_offset) - global_position
		if distance.length() >= min_cursor_distance:
			var direction: Vector2 = global_position.direction_to(current_cursor.global_position + cursor_offset)
			velocity = direction * movement_speed
			move_and_slide()
		
		else:
			move_and_collide(distance * (movement_speed * 0.1) * delta)
			# HEY! You there! If you want to make it super jittery, move the movement_speed * 0.5
			#global_position = current_cursor.global_position + cursor_offset

#func _on_cursor_interaction_started(cursor: Cursor, node: Node) -> void:
	#if node and (node == self or node.get_parent() == self):
		#current_cursor = cursor
		#cursor_offset = global_position - current_cursor.global_position
		#grabbed.emit(self)
#
#func _on_cursor_interaction_stopped(cursor: Cursor, _node: Node) -> void:
	#if current_cursor == cursor:
		#current_cursor = null 
	#dropped.emit(self)


#func _on_collision_area_entered(other: CollisionPolygon2D) -> void:
	#pass
#
#func _on_collision_area_exited(other: CollisionPolygon2D) -> void:
	#pass



func _on_slop_area_entered(other: Area2D) -> void:
	var pot: Pot = other.get_parent() as Pot
	if not pot or other != pot.ladle_area:
		return
	
	ladle_filled = true
	sprite_slop.modulate = pot.sprite_slop.modulate
	ingredients = pot.ingredients

func _on_slop_area_exited(other: Area2D) -> void:
	if other.get_parent() is not Pot:
		return

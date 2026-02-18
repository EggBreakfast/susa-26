@tool 
class_name PlayerCharacter extends CharacterBody3D

@export_group("Metadata")
@export var id: StringName = &"p1"

@export_group("Locomotion")
@export var movement_speed: float = 8.0
@export var acceleration: float = 32.0
# lower acceleration leads to a "floatier" feel! Good for space vibes

@export_group("Customization")
@export var color: Color = Color.WHITE:
	get:
		return color
	set(value):
		color = value
		if sprite:
			sprite.modulate = color

@export_group("Node References")
@export var sprite: Sprite3D

#@export_group("Locked Camera Axes", "locked_axis_")
#@export var locked_axis_x: bool = false
#@export var locked_axis_y: bool = false
#@export var locked_axis_z: bool = false
#only groups together things that have "Locked_axis" as a prefix!

@onready var input_forward: StringName = &"%s_move_forward" % id
@onready var input_backward: StringName = &"%s_move_backward" % id
@onready var input_right: StringName = &"%s_move_right" % id
@onready var input_left: StringName = &"%s_move_left" % id

func _unhandled_input(event: InputEvent) -> void:
	print_debug(event.device)

func _ready() -> void:
	if sprite:
		sprite.modulate = color


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var movement_input: Vector2 = Input.get_vector(input_left, input_right, input_forward, input_backward)
	
	var camera: Camera3D = get_viewport().get_camera_3d()
	# Make sure there's actually a camera! It this command here yonder doesn't work properly if there's no camera
	var camera_forward: Vector3 = camera.global_basis.z
	var camera_right: Vector3 = camera.global_basis.x
	
	var movement_direction: Vector3 = ((camera_forward * movement_input.y) + (camera_right * movement_input.x)).normalized()
	# Normalize makes it a value between 0 and 1; not an actual value. We just want to know the direction!
	velocity = velocity.move_toward(movement_direction * movement_speed, acceleration * delta)
	velocity.y += get_gravity().y
	move_and_slide()

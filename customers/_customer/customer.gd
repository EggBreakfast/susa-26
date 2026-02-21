class_name Customer extends Node2D

static var instance: Customer
# static variable belongs to the class itself, not instances of the class

@export var data: CustomerData

@export var offset: Vector2
@export var facial_expressions: Dictionary[StringName, Texture2D]

@export var sprite_body: AnimatedSprite2D

var timer_duration: float
@export var customer_timer: CustomerTimer

# @export var sprite_face: Sprite2D

#var facial_expression: StringName = facial_expression.keys()[0]:
	#get:
		#return facial_expression
	#set (value):
		#facial_expression = value
		#if sprite_face:
			#sprite_face.texture = facial_expressions.get(facial_expression)


func _ready() -> void:
	if instance:
		push_error("Singleton violation!!")
	instance = self
	
	#facial_expression = &"smile"
	
	timer_duration = randf_range(data.min_timer_duration, data.max_timer_duration)
	customer_timer.max_value = timer_duration
	customer_timer.value = timer_duration
	
	sprite_body.sprite_frames = data.sprite_frames
	
	#position.y -= sprite_body.get_rect().size.y

func _process(delta: float) -> void:
	timer_duration -= delta
	customer_timer.value = timer_duration
	

func _exit_tree() -> void:
	instance = null
# When customer leaves scene, make it so we're no longer thinking about it

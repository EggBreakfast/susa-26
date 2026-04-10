@tool
class_name AnimationHandler extends Node

@export var animated_sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer

func _ready() -> void:
	SignalBroker.customer_animation_idle.connect(_on_customer_idle)
	SignalBroker.customer_animation_talking.connect(_on_customer_talking)
	SignalBroker.customer_animation_eating.connect(_on_customer_eating)
	

func _exit_tree() -> void:
	pass



func _on_customer_idle (customer):
	pass

func _on_customer_talking (customer):
	pass

func _on_customer_eating (customer):
	pass

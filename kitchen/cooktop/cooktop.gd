class_name Cooktop 
extends Control


@export var patty_scene: PackedScene


func _ready() -> void:
	var patty: Ingredient = patty_scene.instantiate()
	add_child(patty)

class_name Stove extends Node2D

@export var area: Area2D

func _enter_tree() -> void:
	area.body_entered.connect(_on_body_entered)
	#area entered for 2 areas that are 2D !

func _exit_tree() -> void:
	area.body_entered.disconnect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Draggable:
		var draggable: Draggable = body as Draggable
		draggable.global_position = global_position

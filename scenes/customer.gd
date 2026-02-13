class_name CustomerDialogue
extends Node2D

var dialogue_start: bool = false

@export_group("customer_dialogue", "lines_")
@export var lines_placeholder: Array[String] = [
	"Wow, I'm talking",
	"Lines 2",
	"Lines 3",
]

@export var lines_eyeguy: Array[String] = [
	"I AM ALSO TALKING",
	"LINE 2",
	"LINE 3",
]

func _unhandled_key_input(_event: InputEvent) -> void:
	if dialogue_start == true:
		DialogueManager.start_dialogue(global_position, "%s ")

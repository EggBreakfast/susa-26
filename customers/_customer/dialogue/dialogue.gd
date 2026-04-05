class_name Dialogue extends Control


## The speed at which text appears, measured in Letters Per Second
@export var speed: int = 8 #Change to be influenced by customer data later?

static var dialogue_scene: PackedScene = preload("res://customers/_customer/dialogue/dialogue.tscn")

var time_elapsed: float = 0.0
var _text: String
@export var text: String: 
	get:
		return text
	set(value):
		text = value
		time_elapsed = 0.0
		set_process(true)


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	pass

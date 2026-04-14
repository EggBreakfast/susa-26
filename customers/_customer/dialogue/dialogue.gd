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
	SignalBroker.customer_spoke.connect(_on_customer_spoke)
	set_process(false)


func _exit_tree() -> void:
	SignalBroker.customer_spoke.disconnect(_on_customer_spoke)


func _process(delta: float) -> void:
	time_elapsed += delta
	%DialogueText.text = text.substr(0, ceili(time_elapsed * speed))
	if %DialogueText.text == text:
		set_process(false)
		await get_tree().create_timer(1.0).timeout
		visible = false
		SignalBroker.dialogue_finished.emit()


func _on_customer_spoke(text_spoken: String) -> void:
	visible = true
	text = text_spoken

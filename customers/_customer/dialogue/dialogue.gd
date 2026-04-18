class_name Dialogue extends Control

## The speed at which text appears, measured in Letters Per Second
@export var speed: int = 8 #Change to be influenced by customer data later?

@export var customer_detect_area: Area2D

static var dialogue_scene: PackedScene = preload("res://customers/_customer/dialogue/dialogue.tscn")

var time_elapsed: float = 0.0
#var _text: String
@export var text: String: 
	get:
		return text
	set(value):
		text = value
		time_elapsed = 0.0
		set_process(true)


func _ready() -> void:
	SignalBroker.customer_spoke.connect(_on_customer_spoke)
	customer_detect_area.area_entered.connect(_on_area_entered)


func _exit_tree() -> void:
	SignalBroker.customer_spoke.disconnect(_on_customer_spoke)
	customer_detect_area.area_entered.disconnect(_on_area_entered)


#func _float() -> void:
	#var tween: Tween = get_tree().create_tween()
	#tween.set_ease(Tween.EASE_OUT)
	#tween.tween_property()
	


func _process(delta: float) -> void:
	time_elapsed += delta
	#if %DialogueText.text.length() <+  47.0 :
	%DialogueText.text = text.substr(0, ceili(time_elapsed * speed))
	#elif %DialogueText.text.length() > 10.0:
		#%DialogueText.text.indent
	if %DialogueText.text == text:
		set_process(false)
		await get_tree().create_timer(1.0).timeout
		visible = false
		SignalBroker.dialogue_finished.emit()


func _on_area_entered(other: Node) -> void:
	var current_customer: Customer = other.get_parent() as Customer
	if not current_customer: 
		return
	else:
		speed = current_customer.data.talking_speed


func _on_customer_spoke(text_spoken: String) -> void:
	visible = true
	text = text_spoken

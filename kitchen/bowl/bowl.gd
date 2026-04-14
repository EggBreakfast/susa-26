class_name Bowl extends CharacterBody2D

@export var sprite_slop: Sprite2D
@export var area: Area2D


var bowl_filled: bool = false
var ingredients: Array[IngredientData]

var current_cursor: Cursor
var cursor_offset: Vector2


func _ready() -> void:
	SignalBroker.bowl_delivered_to_customer.connect(_on_bowl_delivered)
	area.area_entered.connect(_on_area_entered)

func _exit_tree() -> void:
	SignalBroker.bowl_delivered_to_customer.disconnect(_on_bowl_delivered)
	area.area_entered.disconnect(_on_area_entered)

func _on_area_entered(other: Node) -> void:
	var parent: Node = other.get_parent()
	
	if parent is Ladle and parent.ladle_filled and other == parent.slop_area:
		return _on_ladle_entered(parent)




func _on_ladle_entered(ladle: Ladle) -> void: 
	# transfer contents to bowl
	bowl_filled = true
	sprite_slop.modulate = ladle.sprite_slop.modulate
	ingredients = ladle.ingredients
	print_debug(ingredients)
	
	# clear out ladle's contents!
	ladle.ladle_filled = false
	ladle.sprite_slop.modulate = Color.TRANSPARENT
	ladle.ingredients = []


func _on_bowl_delivered(bowl: Bowl) -> void:
	if bowl != self: 
		return
	
	await get_tree().process_frame
	ingredients = []
	bowl_filled = false

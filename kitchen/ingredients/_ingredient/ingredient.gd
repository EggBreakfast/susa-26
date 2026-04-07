class_name Ingredient
extends AnimatableBody2D

#signal grabbed(ingredient: Ingredient)
#signal dropped(ingredient: Ingredient)

@export var data: IngredientData

@export_group("Node References")
@export var area: Area2D
@export var sprite: Sprite2D

var prep_percentage: float = 0.0

var is_raw: bool:
	get:
		return prep_percentage < 1.0
var is_prepped: bool:
	get:
		return prep_percentage >= 1.0 and prep_percentage < data.overprep_percentage
var is_overprepped: bool:
	get:
		return prep_percentage >= data.overprep_percentage


@warning_ignore ("unused_parameter")
func _process(delta: float) -> void:
	#if current_cursor:
		#global_position = current_cursor.global_position + cursor_offset
	
	if prep_percentage >= 1.0 and prep_percentage < data.overprep_percentage:
		sprite.texture = data.texture_prepped
		sprite.modulate = data.modulate_prepped
	
	if prep_percentage >= data.overprep_percentage:
		sprite.texture = data.texture_overprepped
		sprite.modulate = data.modulate_overprepped

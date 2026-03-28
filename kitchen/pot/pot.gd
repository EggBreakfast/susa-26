class_name Pot extends Node2D


@export var ingredient_area: Area2D
@export var ladle_area: Area2D
@export var sprite_slop: Sprite2D


var ingredients: Array[Ingredient]


func _ready() -> void:
	ingredient_area.area_entered.connect(_on_ingredient_area_entered)
	ingredient_area.area_exited.connect(_on_ingredient_area_exited)

func _exit_tree() -> void:
	ingredient_area.area_entered.disconnect(_on_ingredient_area_entered)
	ingredient_area.area_exited.disconnect(_on_ingredient_area_exited)

func _on_ingredient_area_entered(other: Area2D) -> void:
	var ingredient: Ingredient = other.get_parent() as Ingredient
	if not ingredient: 
		return
	
	ingredient.dropped.connect(_on_ingredient_dropped)

func _on_ingredient_area_exited(other: Area2D) -> void:
	var ingredient: Ingredient = other.get_parent() as Ingredient
	if not ingredient: 
		return
	
	ingredient.dropped.disconnect(_on_ingredient_dropped)


func _on_ingredient_dropped(ingredient: Ingredient) -> void: 
	ingredient.get_parent().remove_child(ingredient)
	ingredients.append(ingredient)
	sprite_slop.modulate.r += ingredient.data.color_shift.x
	sprite_slop.modulate.g += ingredient.data.color_shift.y
	sprite_slop.modulate.b += ingredient.data.color_shift.x
	sprite_slop.modulate.a = 0.89
	# r, g, b, a

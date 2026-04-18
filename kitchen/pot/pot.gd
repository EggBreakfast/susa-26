class_name Pot extends Node2D


@export var ingredient_area: Area2D
@export var ladle_area: Area2D
@export var sprite_slop: Sprite2D


var ingredients: Array[IngredientData]


func _ready() -> void:
	SignalBroker.bowl_delivered_to_customer.connect(_on_bowl_delivered)
	
	ingredient_area.area_entered.connect(_on_ingredient_area_entered)
	ingredient_area.area_exited.connect(_on_ingredient_area_exited)
	
	ladle_area.area_entered.connect(_on_ladle_area_entered)
	ladle_area.area_exited.connect(_on_ladle_area_exited)

func _exit_tree() -> void:
	SignalBroker.bowl_delivered_to_customer.disconnect(_on_bowl_delivered)
	
	ingredient_area.area_entered.disconnect(_on_ingredient_area_entered)
	ingredient_area.area_exited.disconnect(_on_ingredient_area_exited)


func _on_bowl_delivered() -> void:
	ingredients = []


func _on_ingredient_area_entered(other: Area2D) -> void:
	var ingredient: Ingredient = other.get_parent() as Ingredient
	if not ingredient: 
		return
	
	var draggable_component = Helpers.find_node_of_type(ingredient, PickupComponent)
	draggable_component.dropped.connect(_on_ingredient_dropped)

func _on_ingredient_area_exited(other: Area2D) -> void:
	var ingredient: Ingredient = other.get_parent() as Ingredient
	if not ingredient: 
		return
	
	var draggable_component = Helpers.find_node_of_type(ingredient, PickupComponent)
	draggable_component.dropped.disconnect(_on_ingredient_dropped)

func _on_ingredient_dropped(ingredient: Ingredient) -> void: 
	ingredient.get_parent().remove_child(ingredient)
	ingredients.append(ingredient.data)
	sprite_slop.modulate.r = clampf(sprite_slop.modulate.r + ingredient.data.color_shift.x, 0.0, 1.0)
	sprite_slop.modulate.g = clampf(sprite_slop.modulate.g + ingredient.data.color_shift.y, 0.0, 1.0)
	sprite_slop.modulate.b = clampf(sprite_slop.modulate.b + ingredient.data.color_shift.z, 0.0, 1.0)
	sprite_slop.modulate.a = 0.89
	print_debug("Pot Ingredients: "+ ingredient.data.to_string())
	
	# r, g, b, a


func _on_ladle_area_entered(other: Area2D) -> void:
	if other.get_parent() is not Ladle:
		return
	

func _on_ladle_area_exited(other: Area2D) -> void:
	var ladle: Ladle = other.get_parent() as Ladle
	if not ladle:
		return

class_name GroceryStore extends Control

@export var ingredients: Array[IngredientData]


func _ready() -> void:
	%TemplateItem.visible = false
	
	SignalBroker.currency_updated.connect(_on_currency_updated)
	_on_currency_updated(SaveSystem.current_save_data.currency)
	
	for ingredient: IngredientData in ingredients:
		_create_ingredient_button(ingredient)

func _exit_tree() -> void:
	SignalBroker.currency_updated.disconnect(_on_currency_updated)


func _on_currency_updated(currency: int) -> void:
	%CurrentMoney.text = "Money: $%0.2f" % (float(currency) / 100.0)


func _create_ingredient_button(ingredient: IngredientData) -> void:
	# Create copy of template
	var template: PanelContainer = %TemplateItem.duplicate()
	
	# Add copy to scene tree
	%TemplateItem.get_parent().add_child(template)
	
	# Swap out copy's stuff for the new stuff
	var item_image: TextureRect = Helpers.find_node_of_type(template, TextureRect)
	item_image.texture = ingredient.texture_raw
	var labels: Array[Node] = Helpers.find_nodes_of_type(template, Label)
	labels[0].text = ("$%0.2f" % (float(ingredient.price)/100.0))
	labels[2].text = ingredient.display_name
	template.visible = true
	
	# Update the copy's clickable area to match its new size & position
	var hit_area: Area2D = Helpers.find_node_of_type(template, Area2D)
	var collision_shape_2d: CollisionShape2D = hit_area.get_child(0)
	var rectangle_shape_2d: RectangleShape2D = collision_shape_2d.shape
	
	await get_tree().process_frame
	rectangle_shape_2d.size = template.size
	collision_shape_2d.position = rectangle_shape_2d.size/2
	
	hit_area.area_entered.connect(_on_area_entered.bind(ingredient))
	hit_area.area_exited.connect(_on_area_exited.bind(ingredient))


func _on_area_entered(other: Node, ingredient: IngredientData) -> void:
	var cursor: Cursor = other.get_parent() as Cursor
	if not cursor:
		return
	
	cursor.interaction_stopped.connect(_on_cursor_interaction_stopped.bind(ingredient))

func _on_area_exited(other: Node, ingredient: IngredientData) -> void:
	var cursor: Cursor = other.get_parent() as Cursor
	if not cursor:
		return
	
	cursor.interaction_stopped.disconnect(_on_cursor_interaction_stopped.bind(ingredient))


@warning_ignore("unused_parameter")
func _on_cursor_interaction_stopped(cursor: Cursor, _node: Node, ingredient: IngredientData) -> void:
	if SaveSystem.current_save_data.currency >= ingredient.price:
		SignalBroker.currency_lost.emit(ingredient.price)
		SignalBroker.ingredient_purchased.emit(ingredient)
		print_debug(ingredient.display_name)

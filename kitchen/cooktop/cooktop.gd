class_name Cooktop 
extends Control

#@export var plate_scene: PackedScene
@export_group("Item Scenes")
@export var patty_scene: PackedScene
@export var carrot_scene: PackedScene
@export var bowl_scene: PackedScene


#@export var count_plates: int = 3
@export_group("Item Counts")
@export var count_patties: int = 3
@export var count_bowls: int = 1

var spawn_points: Array[Marker2D]
# What do square brackets do? A lot of things. This one is a nested type. It specifies the kind of array this is. Same for dictionaries!

func _ready() -> void:
	SignalBroker.bowl_delivered_to_customer.connect(_on_bowl_delivered)
	SignalBroker.ingredient_purchased.connect(_on_add_ingredient)
	
	for spawnpt: Marker2D in Helpers.find_nodes_of_type(self, Marker2D):
		spawn_points.append(spawnpt)
	
	await get_tree().process_frame
	
	for i: int in range(count_patties):
		var patty: Ingredient = patty_scene.instantiate()
		add_child(patty)
		patty.global_position = spawn_points[0].global_position
		patty.global_position.y -= (i * 5.0)
	
	#for i: int in range(count_plates):
		#var plate: Plate = plate_scene.instantiate()
		#add_child(plate)
		#plate.global_position = spawn_points[1].global_position
		#plate.global_position.y -= (i * 8.0)
		
		# Here, the square brackets are used to access something from within the array. Here, it's being used to access the [0] thing in the array. Cool beans!
	for i: int in range(count_bowls):
		var bowl: Bowl = bowl_scene.instantiate()
		add_child(bowl)
		bowl.global_position = spawn_points[1].global_position
		bowl.global_position.y -= (i * 5.0)


func _exit_tree() -> void:
		SignalBroker.bowl_delivered_to_customer.disconnect(_on_bowl_delivered)


func _on_bowl_delivered(bowl: Bowl) -> void:
	bowl.global_position = spawn_points[1].global_position

func _on_add_ingredient(ingredient: IngredientData) -> void:
	print_debug("_on_add_ingredient")
	if ingredient.display_name == "Burger Patty":		
		var patty: Ingredient = patty_scene.instantiate()
		add_child(patty)
		patty.global_position = spawn_points[0].global_position
		patty.global_position.y -= (5.0)
	elif ingredient.display_name == "Carrot":		
		var carrot: Ingredient = carrot_scene.instantiate()
		add_child(carrot)
		carrot.global_position = spawn_points[0].global_position
		carrot.global_position.y -= (5.0)
	pass

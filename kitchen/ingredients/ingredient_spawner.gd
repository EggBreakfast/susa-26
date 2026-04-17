#@tool
#class_name SpawnerComponent extends Node
#
#@export var ingredient_scene: Array[PackedScene]
#
#@export var entity: Ingredient
#
#@export_group("Ingredient Counts", "count_")
#@export var count_patties: int = 3
#@export var count_carrots: int = 1
#
#var spawn_points: Array[Marker2D]
## What do square brackets do? A lot of things. This one is a nested type. It specifies the kind of array this is. Same for dictionaries!
#
#func _ready() -> void:
	
	
	#var cooktop: Node = get_path_to(Cooktop)
	#for spawnpt: Marker2D in Helpers.find_nodes_of_type(cooktop, Marker2D):
		#spawn_points.append(spawnpt)
	#
	#
	#for i: int in range(count_plates):
		#var plate: Plate = plate_scene.instantiate()
		#add_child(plate)
		#plate.global_position = spawn_points[1].global_position
		#plate.global_position.y -= (i * 8.0)

	

class_name Cooktop 
extends Control

@export var plate_scene: PackedScene
@export var patty_scene: PackedScene

@export var count_plates: int = 3
@export var count_patties: int = 3

var spawn_points: Array[Marker2D]
# What do square brackets do? A lot of things. This one is a nested type. It specifies the kind of array this is. Same for dictionaries!

func _ready() -> void:
	for spawnpt: Marker2D in Helpers.find_nodes_of_type(self, Marker2D):
		spawn_points.append(spawnpt)
	
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

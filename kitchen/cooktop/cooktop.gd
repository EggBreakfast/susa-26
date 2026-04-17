class_name Cooktop 
extends Control


var spawn_points: Array[Marker2D]

@export var plate_scene: PackedScene
@export var count_plates: int = 3

@export var ingredient_scene: Array[PackedScene]

@export_group("Ingredient Counts", "count_")
@export var count_patties: int = 3
@export var count_carrots: int = 1


func _ready() -> void:
	SignalBroker.bowl_delivered_to_customer.connect(_on_bowl_delivered)
	
	await get_tree().process_frame
	
	for spawnpt: Marker2D in Helpers.find_nodes_of_type(self, Marker2D):
		spawn_points.append(spawnpt)
	
	#for i: int in range(count_patties):
		#var patty: Ingredient = ingredient_scene..instantiate()
		#add_child(patty)
		#patty.global_position = spawn_points[0].global_position
		#patty.global_position.y -= (i * 8.0)
	#for i: int in range(count_plates):
		#var plate: Plate = plate_scene.instantiate()
		#add_child(plate)
		#plate.global_position = spawn_points[1].global_position
		#plate.global_position.y -= (i * 8.0)
		
		# Here, the square brackets are used to access something from within the array. Here, it's being used to access the [0] thing in the array. Cool beans!

func _exit_tree() -> void:
		SignalBroker.bowl_delivered_to_customer.disconnect(_on_bowl_delivered)


func _on_bowl_delivered(bowl: Bowl) -> void:
	bowl.global_position = spawn_points[1].global_position

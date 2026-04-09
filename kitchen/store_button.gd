extends Button

@export var button_area: Area2D

func _ready() -> void:
	var store_button: Button = self
	var area_collision_shape: CollisionShape2D = Helpers.find_node_of_type(store_button, CollisionShape2D)
	var subshape: RectangleShape2D = area_collision_shape.shape
	subshape.size = size
	area_collision_shape.position = subshape.size / 2

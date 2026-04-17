extends Button


@export var button_area: Area2D


func _ready() -> void:
	resize_button_area()
	
	SignalBroker.cursor_spawned.connect(_on_cursor_spawned)


func resize_button_area() -> void:
	var store_button: Button = self
	var area_collision_shape: CollisionShape2D = Helpers.find_node_of_type(store_button, CollisionShape2D)
	var subshape: RectangleShape2D = area_collision_shape.shape
	subshape.size = size
	area_collision_shape.position = subshape.size / 2


func _on_cursor_spawned(cursor: Cursor) -> void:
	cursor.interaction_started.connect(_on_cursor_interact)

func _on_cursor_interact(cursor: Cursor, _node: Node) -> void:
	if(button_area.overlaps_area(Helpers.find_node_of_type(cursor, Area2D))):
		self.pressed.emit()
	
	await get_tree().process_frame
	resize_button_area()



#func _process(delta: float) -> void:
	#var cursor: Cursor = Helpers.find_node_of_type(Node, Cursor)
	#pass

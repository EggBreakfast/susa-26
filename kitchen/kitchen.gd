class_name Kitchen extends Node2D


@export var customers: Array[PackedScene]

@export var customer_spawn_point: Marker2D

@export var cursor_scene: PackedScene
@export var cursor_colors: PackedColorArray

var cursors: Dictionary [int, Cursor]


func _ready() -> void:
	_spawn_customer()
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	SaveSystem.save_loaded.connect(_on_save_system_loaded)

func _exit_tree() -> void:
	Input.joy_connection_changed.disconnect(_on_joy_connection_changed)
	SaveSystem.save_loaded.disconnect(_on_save_system_loaded)


func _on_save_system_loaded(save_data: SaveData) -> void:
	print_debug(save_data.current_round)


func _spawn_customer() -> void:
	if not Customer.instance:
		#var customer: Customer = Customer.new()
		var customer: Customer = customers.pick_random().instantiate()
		customer_spawn_point.add_child(customer)


func _on_joy_connection_changed(device_id: int, is_connection: Variant) -> void:
	print_debug(device_id, " ::", is_connection, "::", Input.get_connected_joypads())
	if is_connection:
		var cursor: Cursor = cursor_scene.instantiate()
		cursor.id = &"p%s" % (device_id + 1)
		cursor.color = cursor_colors[device_id]
		cursors.set(device_id, cursor)
		add_child(cursor)
	
	elif cursors.has(device_id): #"if not connection, and ___ is in the dictionary, do this!"
		var cursor: Cursor = cursors.get(device_id)
		cursor.queue_free()
		cursors.erase(device_id) 

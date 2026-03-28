class_name Kitchen extends Node2D


@export var debug_customer: StringName
@export var customers: Array[PackedScene]

@export var customer_spawn_point: Marker2D

@export var cursor_scene: PackedScene
@export var cursor_colors: PackedColorArray


var cursors: Dictionary [int, Cursor]


func _ready() -> void:
	_spawn_customer()
	
	if Input.get_connected_joypads().size() <= 0:
		_add_player(0)
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	SaveSystem.save_loaded.connect(_on_save_system_loaded)

func _exit_tree() -> void:
	Input.joy_connection_changed.disconnect(_on_joy_connection_changed)
	SaveSystem.save_loaded.disconnect(_on_save_system_loaded)


func _on_save_system_loaded(save_data: SaveData) -> void:
	print_debug("Current save slot: ", save_data.current_round)


func _spawn_customer() -> void:
	if not Customer.instance:
		var customer: Customer
		if OS.is_debug_build() and debug_customer.length() > 0:
			var customer_scene: PackedScene = CustomerRegistry.customer_registry.get(debug_customer)
			if not customer_scene:
				push_error("Attempted to fetch invalid customer from registry.")
				return
			customer = customer_scene.instantiate()
		else: 
			#var customer: Customer = Customer.new()
			customer = customers.pick_random().instantiate()
		
		#customer.modulate.a = 0.0
		customer_spawn_point.add_child.call_deferred(customer)
		# customer.exited.connect(_on_customer_exited)


func _on_joy_connection_changed(device_id: int, is_connection: Variant) -> void:
	print_debug(device_id, " ::", is_connection, "::", Input.get_connected_joypads())
	if is_connection:
		_add_player(device_id)
	
	elif cursors.has(device_id): #"if not connection, and ___ is in the dictionary, do this!"
		_remove_player(device_id)



func _add_player(device_id: int) -> void:
	print_debug(device_id)
	if cursors.has(device_id):
		return
	
	var cursor: Cursor = cursor_scene.instantiate()
	cursor.id = &"p%s" % (device_id + 1)
	cursor.color = cursor_colors[device_id]
	cursors.set(device_id, cursor)
	add_child(cursor)


func _remove_player(device_id: int) -> void:
	var cursor: Cursor = cursors.get(device_id)
	cursor.queue_free()
	cursors.erase(device_id) 

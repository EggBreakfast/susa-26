class_name Kitchen extends Node2D

@export_group("Customers")
@export var debug_customer: StringName
@export var customers: Array[PackedScene]
@export var customer_spawn_point: Marker2D

@export_group("Cursors")
@export var cursor_scene: PackedScene
@export var cursor_colors: PackedColorArray

@export_group("Node References")
@export var cursor_canvas_layer: CanvasLayer
@export var customer_container: Control
@export var animation_player: AnimationPlayer
@export var store_button: Button
@export var grocery_store: GroceryStore


var is_in_store: bool = false

var cursors: Dictionary [int, Cursor]


func _ready() -> void:
	_spawn_customer()
	
	if Input.get_connected_joypads().size() <= 0:
		_add_player(0)
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	SaveSystem.save_loaded.connect(_on_save_system_loaded)
	
	store_button.pressed.connect(_on_store_button_pressed)
	grocery_store.ingredient_purchased.connect(_on_ingredient_purchased)

func _exit_tree() -> void:
	Input.joy_connection_changed.disconnect(_on_joy_connection_changed)
	SaveSystem.save_loaded.disconnect(_on_save_system_loaded)
	
	store_button.pressed.connect(_on_store_button_pressed)
	grocery_store.ingredient_purchased.disconnect(_on_ingredient_purchased)


func _on_save_system_loaded(save_data: SaveData) -> void:
	#print_debug("Current save slot: ", save_data.current_round)
	pass


func _on_store_button_pressed() -> void:
	is_in_store = !is_in_store
	if is_in_store: 
		store_button.text = "Back to Kitchen"
		animation_player.play(&"slide_to_store")
	else:
		store_button.text = "Store"
		animation_player.play_backwards(&"slide_to_store")

func _on_ingredient_purchased(ingredient_data: IngredientData) -> void:
	# TODO: Create a new instance of the given ingredient and spawn it in its appropriate sp.
	var ingredient_scene: PackedScene = load(ingredient_data.scene_path)
	var ingredient: Ingredient = ingredient_scene.instantiate()
	pass


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
	# print_debug(device_id, " ::", is_connection, "::", Input.get_connected_joypads())
	if is_connection:
		_add_player(device_id)
	
	elif cursors.has(device_id): #"if not connection, and ___ is in the dictionary, do this!"
		_remove_player(device_id)


func _add_player(device_id: int) -> void:
	# print_debug(device_id)
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

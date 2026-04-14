class_name Customer extends Node2D

static var instance: Customer
# static variable belongs to the class itself, not instances of the class

@export var data: CustomerData

@export var offset: Vector2
@export var facial_expressions: Dictionary[StringName, Texture2D]

@export var sprite_body: AnimatedSprite2D

var timer_duration: float
@export var customer_timer: CustomerTimer


# @export var sprite_face: Sprite2D

#var facial_expression: StringName = facial_expression.keys()[0]:
	#get:
		#return facial_expression
	#set (value):
		#facial_expression = value
		#if sprite_face:
			#sprite_face.texture = facial_expressions.get(facial_expression)

var current_order: Order
func _ready() -> void:
	if instance:
		push_error("Singleton violation!!")
	instance = self
	
	SignalBroker.bowl_delivered_to_customer.connect(_on_bowl_delivered)
	
	timer_duration = randf_range(data.min_timer_duration, data.max_timer_duration)
	customer_timer.max_value = timer_duration
	customer_timer.value = timer_duration
	
	sprite_body.sprite_frames = data.sprite_frames
	
	if data.orders.size() < 1:
		return
	else:
		current_order = data.orders.pick_random()
		#print_debug(current_order.dialogue)
	#
	#print_debug("Current Order" + current_order.ingredients[1].to_string())
	#order = data.order.pick_random()
	#SignalBroker.customer.order.pick_random()
	
	#position.y -= sprite_body.get_rect().size.y

func _process(delta: float) -> void:
	timer_duration -= delta
	customer_timer.value = timer_duration
	

func _exit_tree() -> void:
	instance = null # When customer leaves scene, make it so we're no longer thinking about it
	
	SignalBroker.bowl_delivered_to_customer.disconnect(_on_bowl_delivered)


func _on_bowl_delivered(bowl: Bowl) -> void:
	var bowl_ingredients: Array[IngredientData] = bowl.ingredients.slice(0) # slice makes a copy of a slice of the array! Since we start from 0, we basically just get a copy.
	#print_debug("Ingredients in bowl: ", bowl_ingredients.map(func (data: IngredientData): return data.ingredient_id))
	#print_debug("Order to check against: ", current_order.ingredients.map(func (data: IngredientData): return data.ingredient_id))
	
	var order_accurate: bool = true
	for order_ingredient: IngredientData in current_order.ingredients:
		var bowl_ingredient: IngredientData = _get_ingredient_in_bowl(order_ingredient, bowl_ingredients)
		if not bowl_ingredient:
			order_accurate = false
			break
		
	if bowl_ingredients.size() > 0:
		order_accurate = false
	# TODO: Do something with 'is_order_accurate'


func _get_ingredient_in_bowl(order_ingredient: IngredientData, bowl_ingredients: Array[IngredientData]) -> IngredientData:
	for i: int in range(bowl_ingredients.size()):
		if order_ingredient.ingredient_id == bowl_ingredients[i].ingredient_id:
			var found_ingredient: IngredientData = bowl_ingredients.pop_at(i)
			print_debug("Bowl Ingredients ", bowl_ingredients)
			return found_ingredient
	return null




























	# CODE I HAVE BECOME ATTACHED TO:
	# --------------------------------------------
	#var order_size = current_order.ingredients.size()
	#
	#bowl.ingredients.sort_custom(sort_ascending)
	#current_order.ingredients.sort_custom(sort_ascending)
	#
	#var order_accurate: bool = true
	#if order_size == bowl.ingredients.size():
		#for i in range(bowl.ingredients.size()):
			#if current_order.ingredients[i] != bowl.ingredients[i]:
				#order_accurate = false
				#break # breaks out of the for loop earlier !
			#else:
				#continue
	#else: 
		#order_accurate = false
	#
	#if order_accurate == false:
		#print_debug("Go Die. 0 Stars.")
	#elif order_accurate == true:
		#print_debug("Awesome Food")
#
#
#func sort_ascending(a: IngredientData, b: IngredientData) -> bool: 
	#if a.ingredient_id < b.ingredient_id: # if sort_descending, then a > b
		#return true
	#return false

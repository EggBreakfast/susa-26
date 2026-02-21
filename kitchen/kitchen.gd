class_name Kitchen extends Node2D


@export var customers: Array[PackedScene]

@export var customer_spawn_point: Marker2D

func _ready() -> void:
	if not Customer.instance:
		#var customer: Customer = Customer.new()
		var customer: Customer = customers.pick_random().instantiate()
		customer_spawn_point.add_child(customer)

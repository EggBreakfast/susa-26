class_name CustomerDelivaryArea extends Area2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _exit_tree() -> void:
	area_entered.disconnect(_on_area_entered)
	

func _on_area_entered(other: Area2D) -> void:
	var bowl: Bowl = other.get_parent() as Bowl
	if not bowl or not bowl.bowl_filled:
		return
	
	var pickup_component: PickupComponent = Helpers.find_node_of_type(bowl, PickupComponent)
	pickup_component.dropped.connect(_on_bowl_dropped)

func _on_area_exited(other: Area2D) -> void:
	var bowl: Bowl = other.get_parent() as Bowl
	if not bowl:
		return
	
	var pickup_component: PickupComponent = Helpers.find_node_of_type(bowl, PickupComponent)
	if pickup_component.dropped.is_connected(_on_bowl_dropped):
		pickup_component.dropped.disconnect(_on_bowl_dropped)

func _on_bowl_dropped(bowl: Bowl) -> void:
	SignalBroker.bowl_delivered_to_customer.emit(bowl)

# implied class_name Helpers
extends Node

# Making this a global script makes it load in the game before everything else!


## Return the first [code]Node[/code] of the given [code]type[/code] under the
## given [code]parent[/code]. Will return [code]null[/code] if none are found.
func find_node_of_type(parent: Node, type: Variant, is_recursive: bool = true) -> Node:
	for child: Node in parent.get_children():
		if is_instance_of(child, type):
			return child
		if is_recursive and child.get_child_count() > 0:
			var grandchild: Node = find_node_of_type(child, type)
			if grandchild:
				return grandchild
	return null


## Return all [code]Nodes[/code] of the given [code]type[/code] under the given
## [code]parent[/code].
func find_nodes_of_type(parent: Node, type: Variant, is_recursive: bool = true) -> Array[Node]:
	var nodes: Array[Node]
	
	for child: Node in parent.get_children():
		if is_instance_of(child, type):
			nodes.append(child)
		if is_recursive and child.get_child_count() > 0:
			var grandchildren: Array[Node] = find_nodes_of_type(child, type)
			if grandchildren.size() > 0:
				for grandchild: Node in grandchildren:
					nodes.append(grandchild)
	# .push_back = .append
	#... For whatever reason, they both coexist, but only .append_array exists
	
	return nodes


## Query the state of the PhysicsServer to see if an object lives at a certain point.
## If so, return that object.
func get_node_at_position(global_position: Vector2, canvas_instance_id: int = 0, exclude: Array[RID] = []) -> Node:
	var space_state: PhysicsDirectSpaceState2D = get_viewport().find_world_2d().direct_space_state
	# The current state of all physics things in the world as math (a buncha numbers)
	var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	# Create query that describes what we're looking for
	query.position = global_position
	query.canvas_instance_id = canvas_instance_id
	query.exclude = exclude
	query.collide_with_areas = true
	
	var results = space_state.intersect_point(query)
	# Draws a shape and we can see what intersects with it and makes an array of what lives at that point
	if results:
		return results[0].collider # Return first node found!
	return null
	
	# Thank you Mr. Stevie M. for this wonderful code.

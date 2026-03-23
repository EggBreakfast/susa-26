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

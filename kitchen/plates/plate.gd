class_name Plate extends Node2D

#@export var texture_clean: Texture2D
#@export var texture_dirty: Texture2D
#@export var sprite: Sprite2D
#@export var modulate_dirty: Color = Color.WHITE
#
#static var active_cursors: Dictionary [Cursor, Plate]
#
#var is_dirty: bool = false:
	#set(value):
		#is_dirty = value
		#if is_dirty:
			#sprite.texture = texture_dirty
		#else: 
			#sprite.texture = texture_clean
			#sprite.modulate = modulate_dirty
#
#
#func _ready() -> void:
	#area.area_entered.connect(_on_area_entered)
	#area.area_exited.connect(_on_area_exited)
#
#
#func _exit_tree() -> void:
	#area.area_entered.disconnect(_on_area_entered)
	#area.area_exited.disconnect(_on_area_exited)
#
#
#func _on_area_entered(other: Area2D) -> void:
	#var other_parent: Node = other.get_parent()
	#
	#if other_parent is Cursor:
		#other_parent.interaction_started.connect(_on_cursor_interaction_started)
		#other_parent.interaction_stopped.connect(_on_cursor_interaction_stopped)
		#return
	#
	#if other_parent is Ingredient:
		#other_parent.interaction_started.connect(_on_ingredient_grabbed)
		#other_parent.interaction_stopped.connect(_on_ingredient_dropped)
	#
#
#
#func _on_area_exited(other: Area2D) -> void:
	#var other_parent: Node = other.get_parent()
	#
	#if other_parent is Cursor:
		#other_parent.interaction_started.disconnect(_on_cursor_interaction_started)
		#other_parent.interaction_stopped.disconnect(_on_cursor_interaction_stopped)
		#return
	#
	#if other_parent is Ingredient:
		#other_parent.interaction_started.disconnect(_on_ingredient_grabbed)
		#other_parent.interaction_stopped.disconnect(_on_ingredient_dropped)
#
#func _on_cursor_interaction_started(cursor: Cursor) -> void:
	#current_cursor = cursor
	#cursor_offset = global_position - current_cursor.global_position
	#grabbed.emit(self)
#
#func _on_cursor_interaction_stopped(cursor: Cursor) -> void:
	#if current_cursor == cursor:
		#current_cursor = null #Player 2 can no longer steal items from Player 1
	#dropped.emit(self)
#
#
#func _on_ingredient_grabbed(ingredient: Ingredient) -> void:
	 #
	#print_debug("%s grabbed" % ingredient)
#
#
#func _on_ingredient_dropped(ingredient: Ingredient) -> void:
	 #print_debug("%s dropped" % ingredient)
#
#
#
#
#
#@warning_ignore ("unused_parameter")
#func _process(delta: float) -> void:
	#if current_cursor:
		#global_position = current_cursor.global_position + cursor_offset
	#
	#if prep_percentage >= 1.0 and prep_percentage < data.overprep_percentage:
		#sprite.texture = data.texture_prepped
		#sprite.modulate = data.modulate_prepped
	#
	#if prep_percentage >= data.overprep_percentage:
		#sprite.texture = data.texture_overprepped
		#sprite.modulate = data.modulate_overprepped

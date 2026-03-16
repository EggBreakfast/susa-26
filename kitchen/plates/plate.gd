class_name Plate extends Node2D

@export var texture_clean: Texture2D
@export var texture_dirty: Texture2D
@export var sprite: Sprite2D

@export var modulate_dirty: Color = Color.WHITE

var is_dirty: bool = false:
	set(value):
		is_dirty = value
		if is_dirty:
			sprite.texture = texture_dirty
		else: 
			sprite.texture = texture_clean
			sprite.modulate = modulate_dirty

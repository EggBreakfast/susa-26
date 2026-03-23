#implied class_name TransitionSystem
extends Node


var canvas_layer: CanvasLayer = CanvasLayer.new()
var color_rect: ColorRect = ColorRect.new()

var default_color: Color = Color(0.034, 0.078, 0.183, 1.0)
var default_duration: float = 0.5
var transparent: Color = Color.TRANSPARENT


@warning_ignore_start("unused_parameter")
func fade_to_color(color := default_color, duration := default_duration) -> void:
	_setup()
	
	color_rect.color = color
	color_rect.color.a  = 0.0
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(color_rect, ^"color:a", color.a, duration)
	await tween.finished
	


func fade_from_color(color := default_color, duration := default_duration, ) -> void: 
	_setup()
	
	color_rect.color = color
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(color_rect, ^"color:a", 0.0, duration)
	await tween.finished
	
	canvas_layer.get_parent().remove_child(canvas_layer)


func load_scene(path: String, color := default_color, duration := default_duration, ) -> void:
	await fade_to_color(color, duration)
	
	get_tree().change_scene_to_file(path)
	
	await fade_from_color(color, duration)



func _setup() -> void:
	if not canvas_layer.is_inside_tree():
		get_tree().root.add_child(canvas_layer)
	
	if not color_rect.is_inside_tree():
		canvas_layer.add_child(color_rect)
	
	canvas_layer.layer = 100
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

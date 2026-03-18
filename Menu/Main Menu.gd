extends Node2D

@export var sceneName : StringName
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(sceneName)

func _on_options_pressed() -> void:
	#get_tree().change_scene_to_file()
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()

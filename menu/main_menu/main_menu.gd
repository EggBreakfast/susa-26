class_name MainManu extends Node2D


@export var kitchen_scene_path: StringName
@export var data_menu_path: StringName


func _ready() -> void:
	if SaveSystem.get_all_saves().size() <= 0:
		%ButtonContinue.visible = false
		%ButtonLoadGame.visible = false
	
	%ButtonContinue.pressed.connect(_on_button_continue_pressed)
	%ButtonNewGame.pressed.connect(_on_button_new_game_pressed)
	%ButtonLoadGame.pressed.connect(_on_button_load_game_pressed)
	%ButtonSettings.pressed.connect(_on_button_settings_pressed)
	%ButtonExit.pressed.connect(_on_button_exit_pressed)


func _exit_tree() -> void:
	%ButtonContinue.pressed.disconnect(_on_button_continue_pressed)
	%ButtonNewGame.pressed.disconnect(_on_button_new_game_pressed)
	%ButtonLoadGame.pressed.disconnect(_on_button_load_game_pressed)
	%ButtonSettings.pressed.disconnect(_on_button_settings_pressed)
	%ButtonExit.pressed.disconnect(_on_button_exit_pressed)



func _on_button_continue_pressed() -> void:
	pass

func _on_button_new_game_pressed() -> void:
	TransitionSystem.load_scene(kitchen_scene_path)

func _on_button_load_game_pressed() -> void:
	TransitionSystem.load_scene(data_menu_path)

func _on_button_settings_pressed() -> void:
	pass

func _on_button_exit_pressed() -> void:
	get_tree().quit()

extends Node2D


var kitchen_scene_path: String = "res://kitchen/kitchen.tcsn"


func _ready() -> void:
	%Template.visible = false
	
	var saves: Array[SaveData] = SaveSystem.get_all_saves()
	
	if saves.size() <= 0:
		%NoSavesLabel.visible = true	
	
	for saveslot: int in range(saves.size()):
		var save: SaveData = saves[saveslot]
		var template: PanelContainer = $Template.duplicate()
		template.visible = true
		%Template.get_parent().add_child(template)
		var slot_label: Label = template.get_node(^"HBoxContainer/PanelContainer/Label")
		slot_label.text = str(saveslot + 1)
		
		var date_time_label: Label = template.get_node(^"HBoxContainer/MarginContainer/VboxContainer/VBoxContainer/DateTime")
		date_time_label.text = ("Current Round: %s" % save.current_round)
		template.gui_input.connect(_on_slot_gui_input)



func _on_slot_gui_input(event: InputEvent, slot: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		_load_save_slot(slot)


func _load_save_slot(slot: int) -> void:
	SaveSystem.load_data(slot)
	TransitionSystem.load_scene(kitchen_scene_path)

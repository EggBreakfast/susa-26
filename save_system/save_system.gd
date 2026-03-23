# implied class_name SaveSystem
extends Node


signal save_loaded(save_data: SaveData)
signal save_saved(save_data: SaveData)


## The directory to save and load data to/from. 
const SAVE_DIRECTORY = "user://saves"


## The saved file that is loaded (if any!)
var current_save_data: SaveData


@warning_ignore_start("unused_parameter")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"quick_save"):
		save_data(1, SaveData.new())
	
	if event.is_action_pressed(&"quick_load"):
		load_data(1)


## Load a SaveData file into memory!
func load_data(save_slot: int) -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIRECTORY):
		DirAccess.make_dir_recursive_absolute(SAVE_DIRECTORY)
	
	var filename: String = "%s/save-%s.json" % [ SAVE_DIRECTORY, save_slot]
	var file_access: FileAccess = FileAccess.open(filename, FileAccess.READ)
	var json: String = file_access.get_as_text()
	current_save_data = SaveData.new()
	current_save_data.from_json(json)
	
	save_loaded.emit(current_save_data)
	
	
	# print_debug(current_save_data.current_round)
	#print_debug("Loading from slot: ", save_slot)


# Save the current SaveData to the disk. oh hoh 
func save_data(save_slot: int, data: SaveData) -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIRECTORY):
		DirAccess.make_dir_recursive_absolute(SAVE_DIRECTORY)
	
	var filename: String = "%s/save-%s.json" % [ SAVE_DIRECTORY, save_slot]
	var json: String = data.to_json()
	var file_access: FileAccess = FileAccess.open(filename, FileAccess.WRITE)
	file_access.store_string(json)
	
	save_saved.emit(current_save_data)
	
	#print_debug("Saving data to slot: ", data.to_json(), " | ", save_slot)


func get_all_saves() -> Array[SaveData]:
	if not DirAccess.dir_exists_absolute(SAVE_DIRECTORY):
		DirAccess.make_dir_recursive_absolute(SAVE_DIRECTORY)
	
	var saves: Array[SaveData] = []
	
	var filenames: PackedStringArray = DirAccess.get_files_at(SAVE_DIRECTORY)
	for filename: String in filenames:
		var filepath: String = "%s/%s" % [SAVE_DIRECTORY, filename]
		var file_access: FileAccess = FileAccess.open(filepath, FileAccess.READ)
		var json: String = file_access.get_as_text()
		var data: SaveData = SaveData.new()
		data.from_json(json)
		saves.append(data)
	
	return saves


# DirAccess: for folders and stuff! You can make new folders, read new folders...
# DON'T SAVE YOUR DATA TO :res// !! Data is READ-ONLY. YOU CAN'T WRITE IN THERE. 
# FileAccess: as the name implies

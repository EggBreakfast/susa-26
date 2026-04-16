class_name CustomerTimer extends TextureProgressBar


signal timeout


var has_been_set: bool = false


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	if value > 0.0:
		value -= delta
	else:
		process_mode = Node.PROCESS_MODE_ALWAYS
		timeout.emit()


func _on_value_changed(v: float) -> void:
	if process_mode == PROCESS_MODE_DISABLED and v > 0.0:
		process_mode = Node.PROCESS_MODE_INHERIT

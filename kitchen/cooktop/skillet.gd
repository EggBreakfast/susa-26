class_name Skillet extends Node2D


@export var area: Area2D
@onready var _progress_bar: TextureProgressBar = $ProgressBar


var _ingredient: Ingredient
#underscore shows that _ingredient is a private variable
var _cook_time: float


func _ready() -> void:
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)

func _exit_tree() -> void:
	area.area_entered.disconnect(_on_area_entered)
	area.area_exited.disconnect(_on_area_exited)

func _on_area_entered(other: Area2D) -> void:
	var ingredient: Ingredient = other.get_parent() as Ingredient
	if not ingredient:
		return
	
	ingredient.grabbed.connect(_on_ingredient_grabbed)
	ingredient.dropped.connect(_on_ingredient_dropped)


func _on_area_exited(other: Area2D) -> void:
	var ingredient: Ingredient = other.get_parent() as Ingredient
	if not ingredient:
		return
	
	ingredient.grabbed.disconnect(_on_ingredient_grabbed)
	ingredient.dropped.disconnect(_on_ingredient_dropped)


func _on_ingredient_dropped(ingredient: Ingredient) -> void:
	ingredient.global_position = global_position #ingredient position snapping
	_ingredient = ingredient
	_cook_time = _ingredient.prep_percentage * _ingredient.data.prep_time
	
	_progress_bar.value = _ingredient.prep_percentage/1.0

@warning_ignore("unused_parameter")
func _on_ingredient_grabbed(ingredient: Ingredient) -> void:
	_ingredient = null
	_cook_time = 0
	_progress_bar.value = 0
	


func _process(delta: float) -> void:
	if not _ingredient:
		return
	
	_cook_time += delta
	_ingredient.prep_percentage = _cook_time / _ingredient.data.prep_time
	_progress_bar.value = clampf(_ingredient.prep_percentage*100.0, 0.0, 100.0)
	#print.debug(_ingredient.prep_percentage)



#Quick tutorial!
# position = position in relation to parent (use if relative)
#global_position = position in relation to world origin (use if absolute)

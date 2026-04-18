class_name IngredientData 
extends Resource

## The way the slop colors will shift when the ingredient is added, sorted by RGB
@export var color_shift: Vector3
# OR: 
# @export var color_shift: Color
# But you can't do negatives, in that scenario


## The name of the ingredient which will display int he UI (i.e. GroceryStore)
@export var display_name: String

## The price it costs to purchase this ingredient from the store in pennies.
@export var price: int

## The set ID of this specific ingredient
@export var ingredient_id: int
# Patty = 1

## The resource path to this ingredient's instantiable scene.
@export var scene_path: String

##How long (in seconds) it should take for this ingredient to be fully "prepped" (cooked, blended, etc.)
@export var prep_time: float = 5.0
## How many multiples of the prep time lead to it being "ruined" (burnt, smushed, etc.)
@export var overprep_percentage: float = 2.0

## Track if ingredient is properly cooked
@export var prepped: bool = false

@export_group ("Textures", "texture_")
 
##The texture to show when this ingredient has not yet been prepped.
@export var texture_raw: Texture2D
##The texture to show when this ingredient has been prepped adequately.
@export var texture_prepped: Texture2D
##The texture to show when this ingredient has been overprepped (burnt).
@export var texture_overprepped: Texture2D


@export_group ("Modulations", "modulate_")

##A "Modulate" for when the ingredient has not yet been prepped
@export var modulate_raw: Color = Color.WHITE
##A "Modulate" for when the ingredient has been prepped
@export var modulate_prepped: Color = Color.WHITE
##A "Modulate" for when the ingredient has been overprepped
@export var modulate_overprepped: Color = Color.WHITE

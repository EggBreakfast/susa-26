class_name SaveData extends Resource


## The current round that the player has reached in their campaign.
@export var current_round: int = 1
@export var hair_color: Color = Color.WHITE


## Serialize this save data to a JSON string
func to_json() -> String:
	return JSON.stringify({
		"current_round": current_round,
		"hair_color": hair_color,
	})


## Deserialize the given JSON string back into save data
func from_json(json: String) -> void:
	var data: Dictionary = JSON.parse_string(json)
	current_round = data.current_round

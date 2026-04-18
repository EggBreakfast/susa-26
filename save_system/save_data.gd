class_name SaveData extends Resource


## The current round that the player has reached in their campaign.
@export var current_round: int = 1

## The player's amount of currency, measured in Pennies.
@export var currency: int = 5000

var end_screen: String = "res://results_screen/ResultsScreen.tscn"

func _init() -> void:
	SignalBroker.currency_earned.connect(_on_currency_earned)
	SignalBroker.currency_lost.connect(_on_currency_lost)


#func _notification(what: int):
	#if what == NOTIFICATION_PREDELETE:
		#SignalBroker.currency_earned.disconnect(_on_currency_earned)
		#SignalBroker.currency_lost.disconnect(_on_currency_lost)


func _on_currency_earned(amount: int) -> void:
	currency += amount
	if currency <= 0:
		currency = 0
	SignalBroker.currency_updated.emit(currency)


func _on_currency_lost(amount: int) -> void:
	currency -= amount
	if currency <= 0:
		currency = 0
		TransitionSystem.load_scene(end_screen)
	SignalBroker.currency_updated.emit(currency)



## Serialize this save data to a JSON string
func to_json() -> String:
	return JSON.stringify({
		"current_round": current_round,
		"currency": currency
	})


## Deserialize the given JSON string back into save data
func from_json(json: String) -> void:
	var data: Dictionary = JSON.parse_string(json)
	current_round = data.current_round
	currency = data.currency

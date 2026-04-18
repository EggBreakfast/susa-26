class_name ResultsScreen extends Control

func _ready() -> void:
	SignalBroker.currency_updated.connect(_on_currency_updated)
	print_debug("results_screen running")
	
	
func _on_currency_updated(currency: int) -> void:
		$MarginContainer/label_end_game.text = "You ran out of money!"
		print_debug("You ran out of money!")

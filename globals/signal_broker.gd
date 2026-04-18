# implied class_name SignalBroker
extends Node

@warning_ignore_start("unused_signal")

## Emitted whenever a bowl of slop is dropped into the CustomerDeliveryArea.
signal bowl_delivered_to_customer(bowl: Bowl)

## Emitted when a customer speaks.
signal customer_spoke (text: String)
## Emitted when a customer finishes speaking.
signal dialogue_finished ()

## Emitted when a button is pressed.
signal button_pressed (button: Button)

## Emitted when a cursor is spawned into the scene
signal cursor_spawned (cursor: Cursor)

signal customer_enters_kitchen ()
signal customer_leaves_kitchen ()

signal ingredient_purchased(ingredient: Ingredient)
signal currency_earned(amount: int)
signal currency_lost(amount: int)
signal currency_updated(amount: int)
signal game_win(win: bool)

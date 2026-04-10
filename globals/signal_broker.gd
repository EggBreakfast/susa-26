# implied class_name SignalBroker
extends Node

@warning_ignore_start("unused_signal")

## Emitted whenever a bowl of slop is dropped into the CustomerDeliveryArea.
signal bowl_delivered_to_customer(bowl: Bowl)

## Emitted when a customer speaks.
signal customer_spoke (text: String)

signal customer_enters_kitchen ()

signal customer_animation_idle (animation: AnimationPlayer)
signal customer_animation_talking (animation: AnimationPlayer)
signal customer_animation_eating (animation: AnimationPlayer)

signal customer_animation_entered (tween: Tween)
signal customer_animation_exited (tween: Tween)

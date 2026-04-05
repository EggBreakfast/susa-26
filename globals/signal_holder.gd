# implied class_name SignalBroker
extends Node

@warning_ignore_start("unused_signal")

## Emitted whenever a bowl of slop is dropped into the CustomerDeliveryArea.
signal bowl_delivered_to_customer(bowl: Bowl)

## Emitted when a customer speaks.
signal customer_spoke (text: String)

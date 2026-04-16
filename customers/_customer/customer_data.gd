class_name CustomerData extends Resource

@export var display_name: String
@export var sprite_frames: SpriteFrames

@export var min_timer_duration: float
@export var max_timer_duration: float

@export var sprite_scale: float

#@export var body_texture: Texture2D

@export var customer_id: int
@export var talking_speed: int

@export var customer_active: bool

@export_group ("Order Information", "order_")
@export var orders: Array[Order]
@export var order_wait_time: float

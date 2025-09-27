extends "res://scripts/fade.gd"

var soap := 0.0

func _ready():
	modulate.a = 0.0
	target_alpha = 0.0

func add_bubbles(amount: float) -> void:
	soap = clamp(soap + amount, 0, 1)
	target_alpha = soap

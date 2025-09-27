extends Sprite2D

@export var fade_speed := 0.1
var target_alpha := 1.0

func _process(_delta):
	modulate.a = lerp(modulate.a, target_alpha, fade_speed)

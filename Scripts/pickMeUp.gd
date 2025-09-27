extends Sprite2D

var is_falling := false
var fall_speed := Vector2.ZERO
@export var gravity := 400.0
@export var fade_speed := 1.0

func pickup_me() -> void:
	is_falling = false
	fall_speed = Vector2.ZERO
	modulate.a = 1.0

func release() -> void:
	is_falling = true

func _process(delta):
	if is_falling:
		fall_speed.y += gravity * delta
		position += fall_speed * delta
		modulate.a = clamp(modulate.a - fade_speed * delta, 0, 1)
		if modulate.a <= 0:
			queue_free()

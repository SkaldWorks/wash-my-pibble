extends Sprite2D

var is_falling := false
var fall_speed := Vector2.ZERO
@export var gravity := 400.0
@export var fade_speed := 1.0

# Called when the object should start falling on its own
func trigger_fall() -> void:
	is_falling = true
	fall_speed = Vector2.ZERO
	modulate.a = 1.0

func _process(delta: float) -> void:
	if is_falling:
		fall_speed.y += gravity * delta
		position += fall_speed * delta
		modulate.a = clamp(modulate.a - fade_speed * delta, 0, 1)
		if modulate.a <= 0:
			queue_free()

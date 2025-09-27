extends Sprite2D

# Falling state
var is_falling := false
var fall_speed := Vector2(0, 0)  # vertical velocity
var gravity := 400.0  # pixels/sec^2
var fade_speed := 1.0  # alpha/sec

func pickup_me():
	is_falling = false
	fall_speed = Vector2.ZERO
	modulate.a = 1.0  # fully visible

func release():
	is_falling = true

func _process(delta):
	if is_falling:
		# Apply gravity
		fall_speed.y += gravity * delta
		position += fall_speed * delta

		# Fade out
		modulate.a -= fade_speed * delta
		modulate.a = clamp(modulate.a, 0, 1)

		# Remove object once invisible
		if modulate.a <= 0:
			queue_free()

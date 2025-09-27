extends Sprite2D

# 0 = fully clean (transparent), 1 = fully dirty (visible)
var dirtiness := 1.0  
func _process(delta):
	# Smoothly interpolate alpha to make fading visually smoother
	modulate.a = lerp(modulate.a, dirtiness, 0.1)

# Called by soap to reduce dirtiness
func reduce_dirtiness(amount: float):
	dirtiness -= amount
	dirtiness = clamp(dirtiness, 0, 1)
	if dirtiness <= 0:
		pass

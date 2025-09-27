extends Sprite2D

# 0 = fully clean (transparent), 1 = fully dirty (visible)
var soap := 0.0  

func _ready():
	modulate.a = 0.0  # start invisible
	
func _process(delta):
	# Smoothly interpolate alpha to make fading visually smoother
	modulate.a = lerp(modulate.a, soap, 0.1)

# Called by soap to reduce dirtiness
func reduce_dirtiness(amount: float):
	soap += amount
	soap = clamp(soap, 0, 1)
	if soap >= 1:
		pass

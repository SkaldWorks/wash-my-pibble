extends Sprite2D

# Dragging state
var is_dragging := false
var mouse_offset := Vector2.ZERO

# Original position and scale to return to
var original_position := Vector2.ZERO
var original_scale := Vector2.ONE

# Scaling speed factor
var scale_factor := 0.005  # adjust for sensitivity

func _ready():
	original_position = position
	original_scale = scale

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			# Start dragging
			is_dragging = true
			mouse_offset = position - event.position
		elif not event.pressed:
			# Stop dragging and snap back
			is_dragging = false
			position = original_position
			scale = original_scale

	if event is InputEventMouseMotion and is_dragging:
		# Move object with mouse
		position = event.position + mouse_offset

		# Adjust scale based on vertical movement
		var delta_y = event.relative.y
		scale += Vector2.ONE * delta_y * scale_factor

		# Clamp scale to reasonable limits
		scale.x = clamp(scale.x, 0.2, 3.0)
		scale.y = clamp(scale.y, 0.2, 3.0)

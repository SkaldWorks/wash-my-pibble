extends Sprite2D

# Dragging state
var is_dragging := false
var mouse_offset := Vector2.ZERO

# Target being cleaned
var over_target: Node = null  

# Original position for snapping back
var original_position := Vector2.ZERO

# Cleaning speed (smaller = slower)
var clean_strength := 0.7

func _ready():
	original_position = position
	$Area2D.area_entered.connect(_on_area_2d_area_entered)
	$Area2D.area_exited.connect(_on_area_2d_area_exited)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			# Start dragging
			is_dragging = true
			mouse_offset = position - event.position
		elif not event.pressed:
			# Stop dragging
			is_dragging = false
			if is_dragging == false:
				# Snap back if not over a target
				position = original_position

	if event is InputEventMouseMotion and is_dragging:
		position = event.position + mouse_offset
		if over_target:
			_clean_target()

# Called when soap enters a dirty object
func _on_area_2d_area_entered(area: Area2D) -> void:
	over_target = area.get_parent()

# Called when soap leaves a dirty object
func _on_area_2d_area_exited(area: Area2D) -> void:
	over_target = null

# Reduce the dirtiness of the target
func _clean_target():
	if over_target and over_target.has_method("reduce_dirtiness"):
		# Multiply by delta for frame-independent cleaning speed
		over_target.reduce_dirtiness(clean_strength * get_process_delta_time())
func _bubble_target():
	if over_target and over_target.has_method("add_bubbles"):
		# Multiply by delta for frame-independent cleaning speed
		over_target.add_bubbles(clean_strength * get_process_delta_time())

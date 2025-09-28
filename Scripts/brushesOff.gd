extends "res://scripts/draggable.gd"

@export var drop_offset := Vector2(0, 0)  # optional offset if you want to trigger fall at a different point

func _ready():
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)
	original_position = position  # set once at start

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			is_dragging = true
			mouse_offset = position - get_global_mouse_position()
		elif not event.pressed:
			is_dragging = false
			# snapping handled automatically in _process

	if event is InputEventMouseMotion and is_dragging:
		position = get_global_mouse_position() + mouse_offset
		# so it always snaps back to the original starting point

func _on_area_entered(area: Area2D) -> void:
	var obj = area.get_parent()
	# If the overlapping object has trigger_fall(), call it but don't attach
	if obj and obj.has_method("trigger_fall"):
		obj.call_deferred("trigger_fall")

func _process(delta: float) -> void:
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)

extends Sprite2D

@export var snap_speed := 8.0  # Higher = faster snap
var is_dragging := false
var mouse_offset := Vector2.ZERO
var original_position := Vector2.ZERO
var snap_target: Node = null  # Current snap target we're overlapping


func _ready() -> void:
	original_position = position
	GameState.ugly_pibble = false
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)
		$Area2D.area_exited.connect(_on_area_exited)


func _input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			_start_drag(event.position)
		elif not event.pressed:
			_stop_drag()

	elif event is InputEventMouseMotion and is_dragging:
		_drag_to(get_global_mouse_position())


func _start_drag(mouse_pos: Vector2) -> void:
	is_dragging = true
	mouse_offset = position - mouse_pos


func _stop_drag() -> void:
	is_dragging = false

	# Snap to target if one exists
	if snap_target and snap_target.is_inside_tree():
		if snap_target.has_method("on_snap"):
			snap_target.call_deferred("on_snap", self)
		# Optionally, leave the sprite visually over the target
		return

	# Otherwise fallback to normal snap-back
	position = original_position


func _drag_to(mouse_pos: Vector2) -> void:
	position = mouse_pos + mouse_offset


func _process(delta: float) -> void:
	if is_dragging:
		# Already handled in _drag_to
		pass
	elif snap_target and snap_target.is_inside_tree():
		# Smoothly move toward snap target
		position = position.lerp(snap_target.global_position, snap_speed * delta)
	else:
		# Default snap-back to original position
		position = position.lerp(original_position, snap_speed * delta)


func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	if parent.is_in_group("SnapTarget"):
		snap_target = parent


func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if snap_target == parent:
		snap_target = null

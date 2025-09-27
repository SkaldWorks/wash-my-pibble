extends "res://scripts/draggable.gd"

# The target we are overlapping and can snap to
var snap_target: Node = null

func _ready() -> void:
	super._ready()
	# connect Area2D signals
	$Area2D.area_entered.connect(_on_area_entered)
	$Area2D.area_exited.connect(_on_area_exited)

func _stop_drag() -> void:
	is_dragging = false

	# Snap if released over a target
	if snap_target and snap_target.is_inside_tree():
		# Optionally, call a method on the target if it wants to know
		if snap_target.has_method("on_snap"):
			snap_target.call_deferred("on_snap", self)
		return

	# Otherwise fallback to normal snap-back handled by base class
	if has_method("_stop_drag"):
		super._stop_drag()


func _process(delta: float) -> void:
	if is_dragging:
		_drag_to(get_global_mouse_position())
	elif snap_target and snap_target.is_inside_tree():
		# Smoothly move to target position
		position = position.lerp(snap_target.global_position, snap_speed * delta)
	else:
		# Default snap-back
		super._process(delta)

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

extends Sprite2D

@export var snap_speed := 8.0 # Higher = faster snap back
@export var min_scale := 0.01
@export var max_scale := 5.0
@export var top_y := 100.0
@export var bottom_y := 800.0
@export var drag_texture: Texture2D  # Texture to use when dragging

var is_dragging := false
var mouse_offset := Vector2.ZERO
var original_position := Vector2.ZERO
var original_scale := Vector2.ONE
var original_texture: Texture2D
var has_reached_target := false  # Once true, never snaps back again


func _ready():
	original_position = position
	original_scale = scale
	original_texture = texture

	# Connect Area2D signals if it exists
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			_start_drag(event.position)
		elif not event.pressed:
			_stop_drag()

	elif event is InputEventMouseMotion and is_dragging:
		_drag_to(event.position)


func _start_drag(mouse_pos: Vector2) -> void:
	is_dragging = true
	mouse_offset = position - mouse_pos

	# Change texture when picked up
	if drag_texture:
		texture = drag_texture


func _stop_drag() -> void:
	is_dragging = false

	# Restore original texture when released
	texture = original_texture


func _drag_to(mouse_pos: Vector2) -> void:
	position = mouse_pos + mouse_offset


func _process(delta: float) -> void:
	if is_dragging:
		# Change size based on Y position (closer = bigger)
		var t = clamp(inverse_lerp(top_y, bottom_y, position.y), 0.0, 1.0)
		scale = Vector2.ONE * lerp(min_scale, max_scale, t)
	else:
		# Only snap back if it has NEVER reached the target
		if not has_reached_target:
			position = position.lerp(original_position, snap_speed * delta)
			scale = scale.lerp(original_scale, snap_speed * delta)
		# Once reached target -> stays wherever it is, no snapping


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "FindPibble":  # Adjust as needed
		has_reached_target = true

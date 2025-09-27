extends Sprite2D

var is_dragging := false
var mouse_offset := Vector2.ZERO
var original_position := Vector2.ZERO
var snap_speed := 8.0 # Higher = faster snap back

func _ready():
	original_position = position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			_start_drag(event.position)
		elif not event.pressed:
			_stop_drag()

	if event is InputEventMouseMotion and is_dragging:
		_drag_to(event.position)

func _start_drag(mouse_pos: Vector2) -> void:
	is_dragging = true
	mouse_offset = position - mouse_pos

func _stop_drag() -> void:
	is_dragging = false
	# no need to call _snap_back() here anymore; handled in _process

func _drag_to(mouse_pos: Vector2) -> void:
	position = mouse_pos + mouse_offset

func _process(delta: float) -> void:
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)

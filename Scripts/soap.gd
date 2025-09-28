extends Sprite2D

@export var snap_speed: float = 8.0       # Speed for snap-back
@export var clean_strength: float = 0.6   # Amount per second applied to target

var is_dragging: bool = false
var mouse_offset: Vector2 = Vector2.ZERO
var original_position: Vector2 = Vector2.ZERO
var over_target: Node = null              # Target currently under the cleaner


func _ready() -> void:
	original_position = position

	# Connect Area2D signal if it exists
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)


func _input(event) -> void:
	# Start drag
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			_start_drag(event.position)
		elif not event.pressed:
			_stop_drag()

	# Drag motion
	elif event is InputEventMouseMotion and is_dragging:
		_drag_to(get_global_mouse_position())


func _start_drag(mouse_pos: Vector2) -> void:
	is_dragging = true
	mouse_offset = position - mouse_pos


func _stop_drag() -> void:
	is_dragging = false


func _drag_to(mouse_pos: Vector2) -> void:
	position = mouse_pos + mouse_offset

	# Apply cleaning and bubble effects while dragging
	if over_target:
		if over_target.has_method("remove_dirt"):
			over_target.call_deferred(
				"remove_dirt", clean_strength * get_process_delta_time()
			)
		if over_target.has_method("add_bubbles"):
			over_target.call_deferred(
				"add_bubbles", clean_strength * get_process_delta_time()
			)


func _process(delta: float) -> void:
	# Smoothly snap back when not dragging
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)


func _on_area_entered(area: Area2D) -> void:
	over_target = area.get_parent()

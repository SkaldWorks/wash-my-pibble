extends Sprite2D

@export var snap_speed := 8.0           # Higher = faster snap-back
@export var clean_strength := 0.5       # How much cleaning per second

var is_dragging := false
var mouse_offset := Vector2.ZERO
var original_position := Vector2.ZERO
var over_target: Node = null            # Current target being cleaned


func _ready() -> void:
	original_position = position

	# Connect Area2D signal if it exists
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)


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


func _drag_to(mouse_pos: Vector2) -> void:
	# Move the sprite
	position = mouse_pos + mouse_offset

	# If over a target, apply cleaning
	if over_target and over_target.has_method("remove_dirt"):
		over_target.call_deferred(
			"remove_dirt", 
			clean_strength * get_process_delta_time()
		)


func _process(delta: float) -> void:
	# Smoothly snap back when not dragging
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)


func _on_area_entered(area: Area2D) -> void:
	# Track the target being cleaned
	over_target = area.get_parent()

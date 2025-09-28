extends Sprite2D

@export var snap_speed: float = 8.0           # Speed of snapping back
@export var hold_strength: float = 0.5        # Effect per second applied to target
@export var default_texture: Texture2D        # Texture when not held
@export var held_texture: Texture2D           # Texture when held

var is_dragging: bool = false
var mouse_offset: Vector2 = Vector2.ZERO
var original_position: Vector2 = Vector2.ZERO
var over_target: Node = null                  # Target currently under the cleaner


func _ready() -> void:
	original_position = position

	# Set default texture initially
	if default_texture:
		texture = default_texture

	# Connect Area2D signals if present
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)
		$Area2D.area_exited.connect(_on_area_exited)


func _input(event) -> void:
	# Handle pick-up and release
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			_on_pick_up()
		elif not event.pressed and is_dragging:
			_on_release()

	# Handle dragging
	elif event is InputEventMouseMotion and is_dragging:
		_drag_to(get_global_mouse_position())


func _process(delta: float) -> void:
	# Apply hold effect while dragging over a target
	if is_dragging and over_target and over_target.is_inside_tree():
		if over_target.has_method("apply_hold_fade"):
			over_target.apply_hold_fade(hold_strength * delta)

	# Smooth snap-back if not dragging
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)


func _start_drag(mouse_pos: Vector2) -> void:
	is_dragging = true
	mouse_offset = position - mouse_pos


func _stop_drag() -> void:
	is_dragging = false


func _drag_to(mouse_pos: Vector2) -> void:
	position = mouse_pos + mouse_offset


func _on_pick_up() -> void:
	is_dragging = true
	if held_texture:
		texture = held_texture


func _on_release() -> void:
	is_dragging = false
	if default_texture:
		texture = default_texture


func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	if parent and parent.has_method("apply_hold_fade"):
		over_target = parent


func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	if over_target == parent:
		over_target = null

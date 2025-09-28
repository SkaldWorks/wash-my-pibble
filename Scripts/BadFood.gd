extends Sprite2D

@export var snap_speed := 8.0               # Higher = faster snap back
@export var respawn_time: float = 3.0       # Seconds until food reappears after being eaten
@export var lose_scene: String = "res://scenes/lose_scene.tscn"  # Optional: scene to load on bad food

var is_dragging := false
var mouse_offset := Vector2.ZERO
var original_position := Vector2.ZERO
var over_eater: Node = null                 # Tracks current eater the food is overlapping


func _ready() -> void:
	# Store starting position
	original_position = position

	# Connect Area2D signals if present
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
		_drag_to(event.position)


func _start_drag(mouse_pos: Vector2) -> void:
	is_dragging = true
	mouse_offset = position - mouse_pos


func _stop_drag() -> void:
	# Handle being eaten if over an eater
	if over_eater and over_eater.is_inside_tree():
		# Notify the eater
		if over_eater.has_method("on_eat"):
			over_eater.call_deferred("on_eat", self)

		# Custom food hook for bad/good effects
		_on_eaten_by(over_eater)

		# Hide & respawn later
		_handle_eaten_and_respawn()
		return

	# Otherwise stop dragging normally
	is_dragging = false


func _drag_to(mouse_pos: Vector2) -> void:
	position = mouse_pos + mouse_offset


# --- Food-specific hook, override for child classes
func _on_eaten_by(eater: Node) -> void:
	# Example: bad food logic
	if eater and eater.has_method("on_bad_eat"):
		eater.call_deferred("on_bad_eat", self)
	# Optional: trigger lose scene if desired
	if lose_scene != "":
		var lose_scene_res = load(lose_scene)
		if lose_scene_res:
			get_tree().change_scene_to(lose_scene_res)


# --- Area2D detection
func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	if parent.is_in_group("Eater"):
		over_eater = parent


func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	if over_eater == parent:
		over_eater = null


# --- Internal: hide, disable, schedule respawn
func _handle_eaten_and_respawn() -> void:
	visible = false
	is_dragging = false
	set_process(false)
	set_process_input(false)

	if $Area2D:
		$Area2D.monitoring = false
		$Area2D.set_deferred("monitorable", false)

	# Schedule respawn timer
	var t = get_tree().create_timer(respawn_time)
	t.timeout.connect(_respawn)


func _respawn() -> void:
	position = original_position
	visible = true
	is_dragging = false
	set_process(true)
	set_process_input(true)
	over_eater = null

	if $Area2D:
		$Area2D.monitoring = true
		$Area2D.set_deferred("monitorable", true)


func _process(delta: float) -> void:
	# Smoothly snap back if not dragging
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)

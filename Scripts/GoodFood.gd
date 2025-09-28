extends Sprite2D

@export var snap_speed: float = 8.0
@export var respawn_time: float = 3.0

var is_dragging: bool = false
var mouse_offset: Vector2 = Vector2.ZERO
var original_position: Vector2 = Vector2.ZERO
var over_eater: Node = null

func _ready() -> void:
	original_position = position
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)
		$Area2D.area_exited.connect(_on_area_exited)

func _input(event: InputEvent) -> void:
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
	if over_eater and over_eater.is_inside_tree():
		if over_eater.has_method("on_eat"):
			over_eater.call_deferred("on_eat", self)
		_on_eaten_by(over_eater)
		_handle_eaten_and_respawn()
		return
	is_dragging = false

func _drag_to(mouse_pos: Vector2) -> void:
	position = mouse_pos + mouse_offset

func _process(delta: float) -> void:
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)

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

func _on_eaten_by(eater: Node) -> void:
	if eater and eater.has_method("on_good_eat"):
		eater.call_deferred("on_good_eat", self)

func _handle_eaten_and_respawn() -> void:
	visible = false
	is_dragging = false
	set_process(false)
	set_process_input(false)
	if has_node("Area2D"):
		$Area2D.monitoring = false
		$Area2D.set_deferred("monitorable", false)
	var timer := get_tree().create_timer(respawn_time)
	timer.timeout.connect(_respawn)

func _respawn() -> void:
	position = original_position
	visible = true
	is_dragging = false
	over_eater = null
	if has_node("Area2D"):
		$Area2D.monitoring = true
		$Area2D.set_deferred("monitorable", true)
	set_process(true)
	set_process_input(true)

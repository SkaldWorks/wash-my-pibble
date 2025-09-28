extends Sprite2D

@export var snap_speed := 8.0 # Higher = faster snap back
@export var pickup_offset := Vector2(60, -60)
@export var pickup_sfx: AudioStream  # assign sound in Inspector

var is_dragging := false
var mouse_offset := Vector2.ZERO
var original_position := Vector2.ZERO
var picked_object: Node2D = null
var sfx_player: AudioStreamPlayer

func _ready():
	original_position = position

	# Setup AudioStreamPlayer
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	sfx_player.stream = pickup_sfx

	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			_start_drag()
		elif not event.pressed and is_dragging:
			_stop_drag()
	elif event is InputEventMouseMotion and is_dragging:
		_drag_to(event.position)

func _start_drag() -> void:
	is_dragging = true
	mouse_offset = position - get_global_mouse_position()

	if picked_object:
		picked_object.call("pickup_me")
		# Play pickup sound
		if sfx_player and pickup_sfx:
			sfx_player.play()

func _stop_drag() -> void:
	is_dragging = false
	if picked_object:
		picked_object.call("release")
		picked_object = null

func _drag_to(mouse_pos: Vector2) -> void:
	position = get_global_mouse_position() + mouse_offset
	if picked_object:
		picked_object.global_position = global_position + pickup_offset
	original_position = position

func _process(delta: float) -> void:
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)

func _on_area_entered(area: Area2D) -> void:
	if not picked_object and area.get_parent().has_method("pickup_me"):
		picked_object = area.get_parent()
		picked_object.call("pickup_me")
		# Play pickup sound
		if sfx_player and pickup_sfx:
			sfx_player.play()

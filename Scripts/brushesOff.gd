extends Sprite2D

@export var snap_speed := 8.0 # Higher = faster snap back
@export var drop_offset := Vector2.ZERO  # Optional offset for triggering fall at a slightly different position
@export var fall_sfx: AudioStream  # Assign the sound effect in the Inspector

var is_dragging := false
var mouse_offset := Vector2.ZERO
var original_position := Vector2.ZERO
var sfx_player: AudioStreamPlayer

func _ready():
	# Store starting position
	original_position = position

	# Setup AudioStreamPlayer
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	sfx_player.stream = fall_sfx

	# Connect Area2D signal if it exists
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


func _stop_drag() -> void:
	is_dragging = false


func _drag_to(mouse_pos: Vector2) -> void:
	position = mouse_pos + mouse_offset


func _on_area_entered(area: Area2D) -> void:
	var obj = area.get_parent()
	if obj and obj.has_method("trigger_fall"):
		obj.call_deferred("trigger_fall")
		# Play the fall sound effect
		if sfx_player and fall_sfx:
			sfx_player.play()


func _process(delta: float) -> void:
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)

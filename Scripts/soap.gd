extends Sprite2D

@export var snap_speed: float = 8.0       # Speed for snap-back
@export var clean_strength: float = 0.6   # Amount per second applied to target
@export var scrub_sfx: AudioStream        # assign the sound effect in Inspector

var is_dragging: bool = false
var mouse_offset: Vector2 = Vector2.ZERO
var original_position: Vector2 = Vector2.ZERO
var over_target: Node = null              # Target currently under the cleaner
var sfx_player: AudioStreamPlayer

func _ready() -> void:
	original_position = position

	# Setup AudioStreamPlayer for scrubbing sound
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	sfx_player.stream = scrub_sfx
	sfx_player.autoplay = false
	sfx_player.loop = true

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
		_drag_to(get_global_mouse_position())


func _start_drag(mouse_pos: Vector2) -> void:
	is_dragging = true
	mouse_offset = position - mouse_pos


func _stop_drag() -> void:
	is_dragging = false
	_stop_scrub_sfx()


func _drag_to(mouse_pos: Vector2) -> void:
	position = mouse_pos + mouse_offset

	# Only apply cleaning if over a target
	if over_target:
		var cleaned = false
		if over_target.has_method("remove_dirt"):
			over_target.call_deferred("remove_dirt", clean_strength * get_process_delta_time())
			cleaned = true
		if over_target.has_method("add_bubbles"):
			over_target.call_deferred("add_bubbles", clean_strength * get_process_delta_time())
			cleaned = true

		# Play sound if cleaning is happening
		if cleaned and sfx_player and not sfx_player.playing:
			sfx_player.play()
		elif not cleaned and sfx_player.playing:
			sfx_player.stop()
	else:
		_stop_scrub_sfx()


func _process(delta: float) -> void:
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)


func _on_area_entered(area: Area2D) -> void:
	over_target = area.get_parent()


func _on_area_exited(area: Area2D) -> void:
	if over_target == area.get_parent():
		over_target = null
		_stop_scrub_sfx()


func _stop_scrub_sfx() -> void:
	if sfx_player and sfx_player.playing:
		sfx_player.stop()

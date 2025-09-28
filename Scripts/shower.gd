extends "res://scripts/draggable.gd"

@export var hold_strength: float = 0.5   # amount per second to send to the target
@export var default_texture: Texture2D    # original sprite
@export var held_texture: Texture2D       # sprite while being held

var over_target: Node = null

func _ready() -> void:
	super._ready()

	# Make sure the default sprite is set at start
	if default_texture:
		texture = default_texture

	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)
		$Area2D.area_exited.connect(_on_area_exited)

func _input(event):
	# Detect pick-up and release
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			_on_pick_up()
		elif not event.pressed and is_dragging:
			_on_release()

	# Call the original draggable input logic
	super._input(event)

func _process(delta: float) -> void:
	# While dragging and overlapping a target, continuously apply hold effect
	if is_dragging and over_target and over_target.is_inside_tree():
		if over_target.has_method("apply_hold_fade"):
			over_target.apply_hold_fade(hold_strength * delta)

	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)


# Called when the cleaner is picked up
func _on_pick_up() -> void:
	if held_texture:
		texture = held_texture

# Called when the cleaner is released
func _on_release() -> void:
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

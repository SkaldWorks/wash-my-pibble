extends "res://scripts/draggable.gd"

@export var erase_strength: float = 0.5   # How fast it erases
@export var default_texture: Texture2D
@export var held_texture: Texture2D

var over_target: Node = null

func _ready() -> void:
	super._ready()
	if default_texture:
		texture = default_texture

	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)
		$Area2D.area_exited.connect(_on_area_exited)

func _input(event):
	# Change appearance when picked up / released
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			_on_pick_up()
		elif not event.pressed and is_dragging:
			_on_release()

	super._input(event)

func _process(delta: float) -> void:
	# While dragging and touching a target, erase it
	if is_dragging and over_target and over_target.is_inside_tree():
		if over_target.has_method("apply_erase_fade"):  # 👈 different method name
			over_target.apply_erase_fade(erase_strength * delta)

	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)


func _on_pick_up() -> void:
	if held_texture:
		texture = held_texture

func _on_release() -> void:
	if default_texture:
		texture = default_texture


func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	# only interact with things that have apply_erase_fade()
	if parent and parent.has_method("apply_erase_fade"):
		over_target = parent

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	if over_target == parent:
		over_target = null

# HoldCleaner.gd
extends "res://scripts/draggable.gd"

@export var hold_strength: float = 0.5   # amount per second to send to the target

var over_target: Node = null

func _ready() -> void:
	super._ready()
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)
		$Area2D.area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	# While dragging and overlapping a target, continuously apply hold effect
	if is_dragging and over_target and over_target.is_inside_tree():
		if over_target.has_method("apply_hold_fade"):
			over_target.apply_hold_fade(hold_strength * delta)
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	# accept any node that implements the unique method "apply_hold_fade"
	if parent and parent.has_method("apply_hold_fade"):
		over_target = parent

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	if over_target == parent:
		over_target = null

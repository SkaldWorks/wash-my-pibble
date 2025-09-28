extends "res://scripts/draggable.gd"

@export var min_scale := 0.01
@export var max_scale := 5.0
@export var top_y := 100.0
@export var bottom_y := 800.0

@export var drag_texture: Texture2D  # assign the texture to use when dragging

var original_scale := Vector2.ONE
var original_texture: Texture2D
var has_reached_target := false  # track if it's inside the target area

func _ready():
	super._ready()
	original_scale = scale
	original_texture = texture  # store original sprite texture

	# Connect to this node's Area2D signals (make sure "Area2D" exists as a child)
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)

func _start_drag(mouse_pos: Vector2) -> void:
	super._start_drag(mouse_pos)
	# change texture when picked up
	if drag_texture:
		texture = drag_texture

func _stop_drag() -> void:
	super._stop_drag()
	# restore original texture when released
	texture = original_texture

func _process(_delta):
	if is_dragging:
		# Change size based on Y position (closer = bigger)
		var t = clamp(inverse_lerp(top_y, bottom_y, position.y), 0.0, 1.0)
		scale = Vector2.ONE * lerp(min_scale, max_scale, t)
	else:
		# Only snap back if it hasn't reached the target
		if not has_reached_target:
			position = position.lerp(original_position, 0.15)
			scale = scale.lerp(original_scale, 0.15)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "FindPibble":  # change this if the parent’s name differs
		has_reached_target = true

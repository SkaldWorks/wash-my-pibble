extends "res://scripts/draggable.gd"

@export var min_scale := 0.01
@export var max_scale := 5.0
@export var top_y := 100.0
@export var bottom_y := 800.0
var original_scale := Vector2.ONE

func _ready():
	super._ready()
	original_scale = scale

func _process(_delta):
	if is_dragging:
		var t = clamp(inverse_lerp(top_y, bottom_y, position.y), 0.0, 1.0)
		scale = Vector2.ONE * lerp(min_scale, max_scale, t)
	else:
		position = position.lerp(original_position, 0.15)
		scale = scale.lerp(original_scale, 0.15)

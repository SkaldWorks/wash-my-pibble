extends "res://scripts/draggable.gd"

var picked_object: Node2D = null
@export var pickup_offset := Vector2(60, -60)

func _ready():
	$Area2D.area_entered.connect(_on_area_entered)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			is_dragging = true
			mouse_offset = position - get_global_mouse_position()
		elif not event.pressed and is_dragging:
			is_dragging = false
			if picked_object:
				picked_object.call("release")
				picked_object = null

	if event is InputEventMouseMotion and is_dragging:
		position = get_global_mouse_position() + mouse_offset
		if picked_object:
			picked_object.global_position = global_position + pickup_offset

func _on_area_entered(area: Area2D) -> void:
	if not picked_object and area.get_parent().has_method("pickup_me"):
		picked_object = area.get_parent()
		picked_object.call("pickup_me")

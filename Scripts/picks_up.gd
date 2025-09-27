extends Sprite2D

# Dragging state
var is_dragging := false
var mouse_offset := Vector2.ZERO

# The object currently picked up
var picked_object: Node2D = null

# Offset relative to tweezers (slightly up and to the right)
var pickup_offset := Vector2(60, -60)

func _ready():
	$Area2D.area_entered.connect(_on_area_2d_area_entered)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.position)):
			is_dragging = true
			mouse_offset = position - event.position
		elif not event.pressed:
			is_dragging = false
			# Release the picked object
			if picked_object:
				if picked_object.has_method("release"):
					picked_object.release()
				picked_object = null

	if event is InputEventMouseMotion and is_dragging:
		# Move tweezers
		position = event.position + mouse_offset
		# Move picked object with offset
		if picked_object:
			picked_object.global_position = global_position + pickup_offset

func _on_area_2d_area_entered(area: Area2D) -> void:
	# Only pick up if not already holding something
	if not picked_object and area.get_parent().has_method("pickup_me"):
		picked_object = area.get_parent()
		picked_object.pickup_me()

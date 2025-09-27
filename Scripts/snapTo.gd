extends Sprite2D

func _ready() -> void:
	# Add to a group so draggables can detect it
	add_to_group("SnapTarget")

# Optional callback when a draggable snaps to this target
func on_snap(item: Node) -> void:
	# Snap item immediately to this position (or you can animate in draggable)
	item.global_position = global_position
	# Optional: lock item to prevent further dragging
	if item.has_method("_stop_drag"):
		item.is_dragging = false

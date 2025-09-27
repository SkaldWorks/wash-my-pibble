extends "res://scripts/draggable.gd"

# If this draggable's Area2D overlaps an eater, this will hold that eater node.
var over_eater: Node = null

func _ready() -> void:
	# call base ready so original_position etc. are set
	if has_method("_ready"):
		super._ready()
	# connect area signals (assumes there's an Area2D child)
	$Area2D.area_entered.connect(_on_area_entered)
	$Area2D.area_exited.connect(_on_area_exited)


# Override stop drag so we can delete the object if released over an eater
func _stop_drag() -> void:
	# If we are over an eater when the mouse is released -> eaten
	if over_eater and over_eater.is_inside_tree():
		# Optional: let eater react (e.g., play sound, increment score).
		# If the eater implements on_eat(picked_node), it will be called.
		if over_eater.has_method("on_eat"):
			over_eater.call_deferred("on_eat", self)
		# Remove the dragged object
		queue_free()
		return

	# Otherwise behave normally (just stop dragging; base handles state)
	if has_method("_stop_drag"):
		super._stop_drag()


# Keep track when our Area2D enters another Area2D
func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	# ignore if the area belongs to this object itself
	if parent == self:
		return

	# Check eater by group membership
	if parent.is_in_group("Eater"):
		over_eater = parent

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	if over_eater == parent:
		over_eater = null

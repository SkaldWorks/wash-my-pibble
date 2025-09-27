extends Sprite2D

func _ready() -> void:
	# Add this node to the "Eater" group so draggable objects can detect it
	add_to_group("Eater")

# Called by draggable when it is released over the eater
func on_eat(item: Node) -> void:
	if item and item.is_inside_tree():
		# Remove the dragged object
		item.call_deferred("queue_free")

extends TextureButton

@export var nodes_to_cycle: Array[PackedScene] = []

# Internal tracking
var current_node: Node = null
var current_index: int = -1
var last_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# Remove previous node if it exists
	if current_node and current_node.is_inside_tree():
		last_position = current_node.global_position
		current_node.queue_free()
	else:
		# Use default position if no previous node
		last_position = Vector2.ZERO

	# Move to the next index
	current_index += 1
	if current_index >= nodes_to_cycle.size():
		current_index = 0  # loop back

	# Instantiate the next node
	if nodes_to_cycle.size() > 0:
		current_node = nodes_to_cycle[current_index].instantiate()
		get_tree().current_scene.add_child(current_node)

		# Place at previous node's position
		if current_node is Node2D:
			current_node.global_position = last_position

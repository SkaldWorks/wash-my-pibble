extends TextureButton

@export var nodes_to_cycle: Array[PackedScene] = []  # List of node scenes to cycle through
@export var spawn_position: Vector2 = Vector2.ZERO    # Where the nodes should appear

var current_node: Node = null
var current_index := 0

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# Delete current node if it exists
	if current_node and current_node.is_inside_tree():
		current_node.queue_free()

	if nodes_to_cycle.size() == 0:
		return

	# Spawn next node
	current_node = nodes_to_cycle[current_index].instantiate()
	get_tree().current_scene.add_child(current_node)

	# Position the node
	if current_node is Node2D:
		current_node.global_position = spawn_position
		# If it has original_position (extends draggable), set it
		current_node.original_position = spawn_position

	# Move to next index (wrap around)
	current_index = (current_index + 1) % nodes_to_cycle.size()

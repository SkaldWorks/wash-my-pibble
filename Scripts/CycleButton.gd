extends TextureButton

@export var node_scenes: Array[PackedScene] = []  # List of nodes to spawn
@export var spawn_position := Vector2.ZERO        # Where nodes should appear

var current_node: Node2D = null
var current_index := 0

func _ready() -> void:
	# Detect the first node already in the scene at spawn_position
	for child in get_tree().current_scene.get_children():
		if child.position == spawn_position:
			current_node = child
			break

	# Connect the button
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# Delete current node if it exists
	if current_node and current_node.is_inside_tree():
		current_node.queue_free()

	# Advance to next index
	current_index += 1
	if current_index >= node_scenes.size():
		current_index = 0  # loop back to first

	_spawn_node(current_index)

func _spawn_node(index: int) -> void:
	if index >= 0 and index < node_scenes.size():
		var scene := node_scenes[index]
		if scene:
			current_node = scene.instantiate() as Node2D
			current_node.position = spawn_position
			# If the node has a "original_position" property, set it for snapping
			if current_node.has_method("set_original_position"):
				current_node.call("set_original_position", spawn_position)
			get_tree().current_scene.add_child(current_node)

extends Node

@export var target_count: int = 5          # Number of nodes in scene to trigger spawn
@export var node_to_add: PackedScene       # Node to instantiate

var spawned := false  # prevent multiple spawns

func _process(_delta: float) -> void:
	if spawned:
		return

	# Count all children of the current scene
	var total_nodes := get_tree().current_scene.get_child_count()

	if total_nodes <= target_count:
		_spawn_node()

func _spawn_node() -> void:
	if node_to_add:
		var new_node = node_to_add.instantiate()
		get_tree().current_scene.add_child(new_node)
		spawned = true
		print("Spawned node:", new_node)

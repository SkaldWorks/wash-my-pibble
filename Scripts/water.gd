extends Sprite2D

@export var fade_speed: float = 1.0         # How fast it disappears
@export var node_to_add: PackedScene        # The button (or any node) to spawn
var erased_level: float = 1.0               # Starts fully visible
var spawned := false                        # Prevent multiple spawns

func _ready() -> void:
	modulate.a = erased_level

# Called by HoldEraser.gd while the eraser is held over it
func apply_erase_fade(amount: float) -> void:
	if spawned:
		return  # Stop doing anything after the node is spawned

	erased_level = clamp(erased_level - amount * fade_speed, 0.0, 1.0)
	modulate.a = erased_level

	# When fully erased, spawn the node and delete self
	if erased_level <= 0.0:
		_spawn_node()
		queue_free()

# Spawns the next node (e.g., a button)
func _spawn_node() -> void:
	if node_to_add:
		var new_node = node_to_add.instantiate()
		get_tree().current_scene.add_child(new_node)
		spawned = true
		print("Spawned node:", new_node)

extends Sprite2D

@export var fade_speed := 0.1               # Speed of fade effect
@export var node_to_add: PackedScene        # Optional node to spawn (if provided)
@export var scales_scene_path: String = "res://Scenes/mechanic scenes/rinse_bubbles.tscn"

var _scales_scene: PackedScene = preload("res://Scenes/mechanic scenes/rinse_bubbles.tscn")

var spawned := false                        # Prevent multiple spawns
var soap := 0.0                             # Fill level
var done_soap := false                      # Has finished filling
var target_alpha := 0.0                     # Current fade target


func _ready() -> void:
	modulate.a = 0.0
	target_alpha = 0.0


func _process(_delta: float) -> void:
	# Smoothly fade toward target alpha
	modulate.a = lerp(modulate.a, target_alpha, fade_speed)


func add_bubbles(amount: float) -> void:
	# Increase soap fill level and update fade target
	soap = clamp(soap + amount, 0.0, 1.0)
	target_alpha = soap

	# When full, trigger node spawn
	if soap >= 1.0 and not done_soap:
		done_soap = true
		_spawn_node()


func _spawn_node() -> void:
	if spawned:
		return
	spawned = true

	# Choose which scene to instantiate
	var scene_to_use: PackedScene = node_to_add if node_to_add else _scales_scene
	if not scene_to_use:
		return

	var inst = scene_to_use.instantiate()
	if not inst:
		return

	# Add the instance to the current scene root (use call_deferred for safety)
	var root = get_tree().current_scene
	if root:
		root.call_deferred("add_child", inst)

		# If it's a Node2D, position it at this node’s global position
		if inst is Node2D:
			inst.global_position = global_position

	# Remove this node once the spawn happens
	queue_free()

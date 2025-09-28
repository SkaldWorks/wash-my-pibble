extends Sprite2D

@export var fade_speed := 0.1                     # How fast the sprite fades
@export var scales_scene_path: String = "res://Scenes/mechanic scenes/bubble.tscn"

var target_alpha := 1.0                            # Current fade target
var dirtiness := 1.0                               # 0 = fully clean, 1 = fully dirty
var _spawned := false                              # Make sure we spawn only once
var _scales_scene: PackedScene = preload("res://Scenes/mechanic scenes/bubble.tscn")


func _process(_delta: float) -> void:
	# Smoothly interpolate alpha toward target_alpha
	modulate.a = lerp(modulate.a, target_alpha, fade_speed)


func remove_dirt(amount: float) -> void:
	# Reduce dirtiness and update fade
	dirtiness = clamp(dirtiness - amount, 0.0, 1.0)
	target_alpha = dirtiness

	# When fully clean, spawn bubble scene once
	if dirtiness <= 0.0 and not _spawned:
		_spawned = true
		_spawn_bubbles()


func _spawn_bubbles() -> void:
	# Instantiate the bubble scene
	var inst = _scales_scene.instantiate()
	if not inst:
		return

	# Add to the current scene root
	var root = get_tree().current_scene
	if root:
		root.call_deferred("add_child", inst)

		# If the new instance is Node2D, position it at this node's global position
		if inst is Node2D:
			inst.global_position = global_position

extends "res://scripts/fade.gd"

# 0 = fully clean (transparent), 1 = fully dirty (visible)
var dirtiness := 1.0

# Packed scene to instantiate when cleaned
@export var scales_scene_path: String = "res://Scenes/mechanic scenes/bubble.tscn"
var _scales_scene: PackedScene = preload("res://Scenes/mechanic scenes/bubble.tscn")

# Make sure we only spawn once
var _spawned := false

func remove_dirt(amount: float) -> void:
	dirtiness = clamp(dirtiness - amount, 0.0, 1.0)
	target_alpha = dirtiness

	# When dirtiness reaches zero, spawn the node (only once)
	if dirtiness <= 0.0 and not _spawned:
		_spawned = true
		_spawn_bubbles()


func _spawn_bubbles() -> void:
	# instantiate the PackedScene
	var inst = _scales_scene.instantiate()
	if not inst:
		return

	# add the instance to the current scene root (so it is part of the active scene)
	var root = get_tree().current_scene
	if root:
		# use call_deferred to avoid timing issues during the current frame
		root.call_deferred("add_child", inst)

		# If the new instance is Node2D, place it at this object's global position
		if inst is Node2D:
			inst.global_position = global_position

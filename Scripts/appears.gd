extends "res://scripts/fade.gd"

var spawned := false  # prevent multiple spawns
var soap := 0.0
var done_soap = false
@export var node_to_add: PackedScene       # Node to instantiate
@export var scales_scene_path: String = "res://Scenes/mechanic scenes/rinse_bubbles.tscn"
var _scales_scene: PackedScene = preload("res://Scenes/mechanic scenes/rinse_bubbles.tscn")

func _ready():
	modulate.a = 0.0
	target_alpha = 0.0

func add_bubbles(amount: float) -> void:
	soap = clamp(soap + amount, 0, 1)
	target_alpha = soap
	if soap >= 1:
		if done_soap == false:
			done_soap = true
			_spawn_node()
func _spawn_node() -> void:
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
		queue_free()

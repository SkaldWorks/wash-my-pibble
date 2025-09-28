extends "res://scripts/fade.gd"

var spawned := false  # prevent multiple spawns
var soap := 0.0
var done_soap = false
@export var node_to_add: PackedScene       # Node to instantiate

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
	if node_to_add:
		var new_node = node_to_add.instantiate()
		get_tree().current_scene.add_child(new_node)
		spawned = true
		print("Spawned node:", new_node)
		

extends "res://scripts/food.gd"

# Optionally export a lose_scene and a threshold (eater can also handle this)
@export var lose_scene: String = "res://scenes/lose_scene.tscn"

func _on_eaten_by(eater: Node) -> void:
	# Inform the eater that a bad food was eaten (if it knows how)
	if eater and eater.has_method("on_bad_eat"):
		eater.call_deferred("on_bad_eat", self)
	# If eater doesn't implement on_bad_eat, you could add fallback logic here.

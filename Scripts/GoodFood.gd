extends "res://scripts/food.gd"

func _on_eaten_by(eater: Node) -> void:
	# Inform the eater that a good food was eaten (if it knows how)
	if eater and eater.has_method("on_good_eat"):
		eater.call_deferred("on_good_eat", self)

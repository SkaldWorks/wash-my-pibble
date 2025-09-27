extends "res://scripts/fade.gd"

var dirtiness := 1.0

func reduce_dirtiness(amount: float) -> void:
	dirtiness = clamp(dirtiness - amount, 0, 1)
	target_alpha = dirtiness

extends "res://scripts/draggable.gd"

@export var clean_strength := 0.6
var over_target: Node = null

func _ready():
	super._ready()
	$Area2D.area_entered.connect(_on_area_entered)
	$Area2D.area_exited.connect(_on_area_exited)

func _drag_to(mouse_pos: Vector2) -> void:
	super._drag_to(mouse_pos)
	if over_target:
		over_target.call_deferred("add_bubbles", clean_strength * get_process_delta_time())

func _on_area_entered(area: Area2D) -> void:
	over_target = area.get_parent()

func _on_area_exited(area: Area2D) -> void:
	over_target = null

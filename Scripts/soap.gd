extends "res://scripts/draggable.gd"

@export var clean_strength := 0.6
var over_target: Node = null

func _ready():
	super._ready()
	$Area2D.area_entered.connect(_on_area_entered)

func _drag_to(mouse_pos: Vector2) -> void:
	super._drag_to(mouse_pos)
	if over_target and over_target.has_method("remove_dirt"):
		over_target.call_deferred("remove_dirt", clean_strength * get_process_delta_time())
	if over_target and over_target.has_method("add_bubbles"):
		over_target.call_deferred("add_bubbles", clean_strength * get_process_delta_time())
	

func _on_area_entered(area: Area2D) -> void:
	over_target = area.get_parent()

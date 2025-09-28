extends "res://scripts/draggable.gd"

@export var clean_strength := 0.5
var over_target: Node = null

func _ready():
	super._ready()
	$Area2D.area_entered.connect(_on_area_entered)

func _drag_to(mouse_pos: Vector2) -> void:
	super._drag_to(mouse_pos)
	if over_target and over_target.has_method("remove_dirt"):
		over_target.call_deferred("remove_dirt", clean_strength * get_process_delta_time())
func _process(delta: float) -> void:
	if not is_dragging:
		position = position.lerp(original_position, snap_speed * delta)


func _on_area_entered(area: Area2D) -> void:
	over_target = area.get_parent()

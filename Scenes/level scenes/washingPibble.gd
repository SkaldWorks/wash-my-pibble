extends AnimatedSprite2D

@export var animation_name: String = "default"  # set the animation to play in the Inspector

# Keep track of overlapping areas
var overlapping_areas: Array = []

func _ready() -> void:
	# Make sure the node has an Area2D child or multiple
	if has_node("Area2D"):
		var area = $Area2D
		area.area_entered.connect(_on_area_entered)
		area.area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if not overlapping_areas.has(area):
		overlapping_areas.append(area)
		_update_animation()

func _on_area_exited(area: Area2D) -> void:
	if overlapping_areas.has(area):
		overlapping_areas.erase(area)
		_update_animation()

func _update_animation() -> void:
	if overlapping_areas.size() >= 2:
		if animation != animation_name or not is_playing():
			animation = animation_name
			play()
	else:
		stop()

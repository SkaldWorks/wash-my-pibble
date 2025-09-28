extends Node2D

@export var button_scene: PackedScene  # assign your TextureButton scene in the Inspector

func _ready() -> void:
	# Connect to Area2D's "area_entered" signal
	$Area2D.area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	# Check if the entered area belongs to the "scales" node
	if area.get_parent().name == "scales":
		_pause_timer()
		_spawn_button()


func _pause_timer() -> void:
	if $Timer:
		$Timer.stop()


func _spawn_button() -> void:
	if button_scene:
		var button = button_scene.instantiate()
		add_child(button)
		# Optional: position the button near the center or wherever you want
		if button is Node2D:
			button.position = Vector2(200, 200)

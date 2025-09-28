extends Sprite2D

@export var paired_scene: PackedScene   # The Sprite2D scene that fades in
@export var fade_speed: float = 1.0     # How quickly the fade happens

var paired_sprite: Sprite2D = null
var fade_progress := 0.0

func _ready() -> void:
	modulate.a = 1.0  # start visible
	
	# Make sure we spawn the paired sprite correctly
	if paired_scene:
		# Instance it
		paired_sprite = paired_scene.instantiate()
		
		# Ensure it's a Sprite2D before continuing
		if paired_sprite is Sprite2D:
			# Add it to the same parent so it stays in the scene when this disappears
			if get_parent():
				get_parent().add_child(paired_sprite)
				paired_sprite.global_position = global_position
				paired_sprite.z_index = z_index + 1  # draw above
				paired_sprite.modulate.a = 0.0  # start invisible
			else:
				push_warning("HoldFadeTarget: no parent found to add paired sprite.")
		else:
			push_warning("Paired scene is not a Sprite2D.")
	else:
		push_warning("No paired scene assigned.")

func apply_hold_fade(amount: float) -> void:
	# Only continue if not fully faded
	if fade_progress >= 1.0:
		return

	fade_progress = clamp(fade_progress + amount * fade_speed, 0.0, 1.0)

	# Fade this sprite out
	modulate.a = 1.0 - fade_progress

	# Fade the paired sprite in
	if paired_sprite:
		paired_sprite.modulate.a = fade_progress

	# Once fully faded, optionally hide or remove this sprite
	if fade_progress >= 1.0:
		queue_free()  # or 'visible = false' if you want to keep it around

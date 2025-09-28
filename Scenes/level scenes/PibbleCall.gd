extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

# Name of the animation to play
@export var animation_name: String = "ring"

# PackedScene to add after the second timeout
@export var spawn_scene: PackedScene

# Flag to check if timer timed out for the first time
var first_timeout_done := false

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	anim_sprite.animation_finished.connect(_on_animation_finished)

func _on_timer_timeout() -> void:
	if not first_timeout_done:
		# First timeout: play animation
		anim_sprite.play(animation_name)
		first_timeout_done = true
	else:
		# Second timeout: spawn node
		if spawn_scene:
			var inst = spawn_scene.instantiate()
			if inst:
				add_child(inst)
				# Optional: position at parent node
				if inst is Node2D:
					inst.position = Vector2.ZERO

func _on_animation_finished() -> void:
	# Restart timer after animation finishes
	timer.start()

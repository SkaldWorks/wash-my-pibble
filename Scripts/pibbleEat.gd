extends AnimatedSprite2D

# thresholds & scene paths you can tweak in the Inspector
@export var bad_threshold: int = 3
@export var lose_scene_path: String = "res://scenes/mechanic scenes/tummy_hurt.tscn"
@export var eated_a_lot: String = "res://scenes/run_away.tscn"


@export var good_animation_threshold: int = 2
@export var good_button_threshold: int = 4
@export var too_much_eat: int = 20
@export var spawn_button_scene: PackedScene

# counts
var bad_count: int = 0
var good_count: int = 0

func _ready() -> void:
	add_to_group("Eater")

# generic on_eat (keeps backwards compatibility)
func on_eat(item: Node) -> void:
	# default: play current animation once if set
	if animation != "":
		play()

# called by bad food
func on_bad_eat(item: Node) -> void:
	bad_count += 1
	# play eat animation if available
	# check loss condition
	if bad_count >= bad_threshold:
		if lose_scene_path != "":
			get_tree().change_scene_to_file(lose_scene_path)
	elif good_count >= 2:
		play('badEatFat')
	else:
		play('badEat')

# called by good food
func on_good_eat(item: Node) -> void:
	good_count += 1
	# play eat animation if available
	if good_count >= good_animation_threshold:
		play("fatEat")
	else:
		play('agoodEat')	

	# spawn a button when a higher threshold is reached
	if good_count >= good_button_threshold and spawn_button_scene:
		var btn = spawn_button_scene.instantiate()
		# add to current scene root (simple)
		var root = get_tree().current_scene
		if root:
			root.call_deferred("add_child", btn)
			# put near eater
			if btn is Node2D:
				btn.global_position = global_position + Vector2(0, 60)
		# Avoid spawning repeatedly: increase good_button_threshold so it won't spawn again, or clear the scene
		good_button_threshold = 9999
	if good_count >= too_much_eat:
		get_tree().change_scene_to_file(eated_a_lot)

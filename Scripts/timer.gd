extends Timer

@export var lose_scene_path: String = "res://Scenes/level scenes/LoseScene.tscn"

@onready var progress_bar: ProgressBar = $ProgressBar

var total_time: float

func _ready() -> void:
	# Save the full duration so we can calculate percentage left
	total_time = wait_time

	# Connect timeout signal
	timeout.connect(_on_timeout)

	# Initialize progress bar
	if progress_bar:
		progress_bar.max_value = total_time
		progress_bar.value = total_time

	# Start automatically (optional, depends on your setup)
	start()

func _process(delta: float) -> void:
	if is_stopped():
		return

	if progress_bar:
		# Update progress bar to match remaining time
		progress_bar.value = time_left

func _on_timeout() -> void:
	if lose_scene_path == "res://Scenes/level scenes/LoseScene.tscn":
		get_tree().change_scene_to_file(lose_scene_path)

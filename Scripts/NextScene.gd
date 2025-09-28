extends TextureButton

var target_scene: String = ""
var _clicked := false  # prevent double clicks

func _ready() -> void:
	# Warn if no scene is set (helps catch setup errors)
	if target_scene == "":
		push_warning("ButtonGoToScene: target_scene is empty; set it in the Inspector.")

	# Connect button press
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if _clicked:
		return
	_clicked = true

	# Use the global clicked_times to choose the next scene
	match GameState.clicked_times:
		0:
			target_scene = "res://Scenes/level scenes/Call to Pibble.tscn"
		1:
			target_scene = "res://Scenes/level scenes/Find Pibble.tscn"
		2:
			target_scene = "res://Scenes/level scenes/takethingsoffpibble.tscn"
		3:
			target_scene = "res://Scenes/level scenes/Feed Pibble.tscn"
		4:
			target_scene = "res://Scenes/level scenes/Wash Pibble.tscn"
		5:
			target_scene = "res://Scenes/level scenes/Dress_Pibble.tscn"
		6:
			target_scene = "res://Scenes/level scenes/Win Screen.tscn"
	if target_scene != "":
		GameState.clicked_times += 1
		get_tree().change_scene_to_file(target_scene)
	else:
		_clicked = false  # reset if no valid scene

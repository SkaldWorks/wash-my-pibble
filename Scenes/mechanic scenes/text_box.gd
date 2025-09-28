extends Node2D

@export var full_text: String = "Pibble is in the forest\nYou must save him!!!\nHe seems skittish, \nif you take too long he might run away!"
@export var char_delay: float = 0.05
@export var button_scene: PackedScene  # assign your TextureButton scene in Inspector
@export var label: Label               # assign your Label node in Inspector

var _current_index := 0
var _timer := 0.0
var _done := false

func _ready() -> void:
	if not label:
		push_error("Label not assigned!")
		return
	if not button_scene:
		push_error("Button scene not assigned!")
		return

	label.text = ""
	_current_index = 0
	_timer = 0.0
	_done = false

func _process(delta: float) -> void:
	if _done or not label:
		return

	_timer += delta
	if _timer >= char_delay:
		label.text += full_text[_current_index]
		_current_index += 1
		_timer = 0.0

		if _current_index >= full_text.length():
			_done = true
			_spawn_button()

func _spawn_button() -> void:
	var button = button_scene.instantiate()
	add_child(button)

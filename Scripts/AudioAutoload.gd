extends Node

@export var first_track: AudioStream
@export var second_track: AudioStream
@export var third_track: AudioStream
@export var fourth_track: AudioStream

var player: AudioStreamPlayer
var current_track := 0
var switched_to_third := false

func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)
	player.finished.connect(_on_track_finished)
	_play_next()  # start with first_track

func _process(_delta: float) -> void:
	if not switched_to_third:
		var gamestate = get_node_or_null("/root/Gamestate")
		if gamestate and gamestate.clicked_times >= 1:
			switched_to_third = true
			_play_third()

func _on_track_finished() -> void:
	# Automatically go to the next track if still in sequence
	if current_track == 0:
		if second_track:
			player.stream = second_track
			player.play()
			current_track = 1
	elif current_track == 2:
		if fourth_track:
			player.stream = fourth_track
			player.play()
			current_track = 3

func _play_next() -> void:
	# Called at startup to play first_track
	if current_track == 0 and first_track:
		player.stream = first_track
		player.play()
		current_track = 0

func _play_third() -> void:
	# Immediately switch to third_track
	if third_track:
		player.stop()
		player.stream = third_track
		player.play()
		current_track = 2

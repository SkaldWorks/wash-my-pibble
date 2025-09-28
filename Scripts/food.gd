extends "res://scripts/draggable.gd"

@export var respawn_time: float = 3.0  # seconds until the food reappears after being eaten

# If this draggable's Area2D overlaps an eater, this will hold that eater node.
var over_eater: Node = null

func _ready() -> void:
	# call base ready so original_position etc. are set
	if has_method("_ready"):
		super._ready()
	# connect area signals (assumes there's an Area2D child)
	$Area2D.area_entered.connect(_on_area_entered)
	$Area2D.area_exited.connect(_on_area_exited)


# Override stop drag so we can handle being eaten
func _stop_drag() -> void:
	# If we are over an eater when the mouse is released -> eaten
	if over_eater and over_eater.is_inside_tree():
		# Let eater react with the generic on_eat hook (keeps backwards compat)
		if over_eater.has_method("on_eat"):
			over_eater.call_deferred("on_eat", self)

		# Allow child classes to react (good/bad food)
		_on_eaten_by(over_eater)

		# Hide & respawn later instead of freeing
		_handle_eaten_and_respawn()
		return

	# Otherwise behave normally (just stop dragging; base handles state)
	if has_method("_stop_drag"):
		super._stop_drag()


# Default empty hook — child classes override this to inform eater of type
func _on_eaten_by(eater: Node) -> void:
	# intentionally empty in base class
	pass


# Keep track when our Area2D enters another Area2D
func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	# ignore if the area belongs to this object itself
	if parent == self:
		return

	# Check eater by group membership
	if parent.is_in_group("Eater"):
		over_eater = parent

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == self:
		return
	if over_eater == parent:
		over_eater = null


# -- internal: hide, disable, start respawn timer
func _handle_eaten_and_respawn() -> void:
	# hide visually & disable interaction
	visible = false
	# disable area monitoring so it won't be re-eaten while hidden
	if $Area2D:
		$Area2D.monitoring = false
		$Area2D.set_deferred("monitorable", false)
	# stop being draggable temporarily
	is_dragging = false
	set_process(false)
	set_process_input(false)

	# schedule respawn
	var t = get_tree().create_timer(respawn_time)
	t.timeout.connect(_respawn)

func _respawn() -> void:
	# Put back to original spot and re-enable everything
	position = original_position
	visible = true
	if $Area2D:
		$Area2D.monitoring = true
		$Area2D.set_deferred("monitorable", true)
	set_process(true)
	set_process_input(true)
	# reset eater ref in case it changed
	over_eater = null

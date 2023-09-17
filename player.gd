extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

const MOVE_LEFT = "move_left"
const MOVE_RIGHT = "move_right"
const MOVE_UP = "move_up"
const MOVE_DOWN = "move_down"

var char_direction = "D"
var current_anim = "Idle"

var in_dialog = false

@onready var _animated_sprite = $Sprite2D
@onready var actionable_finder: Area2D = $Direction/PlayerFinder
@onready var direction_finder: Marker2D = $Direction

func _ready() -> void:
	Events.dialog_started.connect(_dialogue_started)
	DialogueManager.dialogue_ended.connect(_dialogue_ended)

func _dialogue_started():
	in_dialog = true

func _dialogue_ended(resource: DialogueResource):
	in_dialog = false
	

func get_actionables() -> Area2D:
	var actionables = actionable_finder.get_overlapping_areas()
	if actionables.size() > 0:
		return actionables[0]
	return null

func _physics_process(delta: float) -> void:
	if not in_dialog:
		var direction = Vector2.ZERO
		direction.x = Input.get_axis(MOVE_LEFT, MOVE_RIGHT) # Input.get_vector()

		direction.y = Input.get_axis(MOVE_UP, MOVE_DOWN)
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)

		
		if State.mobile_control:
			velocity = velocity/1.0
		move_and_slide()
		_on_velocity_changed()
		

func _on_velocity_changed():
	if velocity.length() > 0:
		current_anim = "Walk"
		char_direction = _on_change_direction()
		set_direction_finder_rotation()
	else:
		current_anim = "Idle"
	_animated_sprite.play(current_anim + char_direction)
	

func set_direction_finder_rotation() -> void:
	match angle_of_direction():
		90.0:
			direction_finder.rotation_degrees = 0
		-90.0,-180.0:
			direction_finder.rotation_degrees = 180
		180.0:
			direction_finder.rotation_degrees = 90
		0.0:
			direction_finder.rotation_degrees = 270
	

func angle_of_direction() -> float:
	return floor((rad_to_deg(velocity.angle()))/90)*90

func _on_change_direction() -> String:
	match angle_of_direction():
		90.0:
			return "D"
		-90.0,-180.0:
			return "U"
		180.0:
			return "L"
		0.0:
			return "R"
	return char_direction

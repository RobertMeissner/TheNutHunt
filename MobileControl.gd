extends Control

var analog_pressed := false
var analog_offset : Vector2 = Vector2.ZERO
var analog_size : Vector2

@onready var analog := %Analog
@onready var stick := $"Analog stick"
@onready var analog_center := $"Analog stick"/Sprite2D

const MOVE_LEFT = "move_left"
const MOVE_RIGHT = "move_right"
const MOVE_UP = "move_up"
const MOVE_DOWN = "move_down"

func _ready():
	analog_size = analog.get_rect().size


func _on_analog_pressed() -> void:
	analog_offset = analog.get_local_mouse_position()
	analog_pressed = true


func _on_analog_button_up() -> void:
	analog_pressed = false


func _on_timer_timeout() -> void:
	var ev = InputEventAction.new()
	if analog_pressed:
		ev.pressed = true
		var local_mouse_position: Vector2 = analog.get_local_mouse_position()
		var touch_position : Vector2 = Vector2.ZERO
		touch_position.x = clamp(local_mouse_position.x - analog_offset.x, -analog_size.x/2, analog_size.x/2)
		touch_position.y = clamp(local_mouse_position.y - analog_offset.y, -analog_size.y/2, analog_size.y/2)

		analog_center.position = touch_position
		var strength : Vector2 = touch_position / (analog_size/2)
		
		Input.action_press(MOVE_RIGHT, strength.x/5)
		Input.action_press(MOVE_LEFT, (1- strength.x)/5)
		Input.action_press(MOVE_DOWN, strength.y/5)
		Input.action_press(MOVE_UP, (1- strength.y)/5)
	else:
		analog_center.position = Vector2.ZERO
		Input.action_release(MOVE_RIGHT)
		Input.action_release(MOVE_LEFT)
		Input.action_release(MOVE_DOWN)
		Input.action_release(MOVE_UP)


func _on_action_pressed() -> void:
	Events.action_button_pressed.emit()

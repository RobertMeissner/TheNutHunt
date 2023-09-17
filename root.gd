extends Node2D

var in_dialog = false
var current_body: Area2D = null

@onready var control = $Control

@onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_dialogue_ended)
	Events.dialog_started.connect(_dialogue_started)
	Events.can_make_party.connect(_can_make_party)
	Events.game_configured.connect(_game_configured)
	Events.action_button_pressed.connect(mobile_action)
	if not State.debug:
		configure_game()
	else:
		_show_world()
		$Music/BackgroundMusic.play()
		State.has_swimming_googles = true
		State.has_done_olives = true
		Events._emit_can_find_nuts()
		
func _show_world() -> void:
	%World.visible = true	
	%Config.visible = false	
	in_dialog = false
	%Player.visible = true	
	%Tutorial.visible = !State.mobile_control

func _game_configured() -> void:
	if State.mobile_control:
		var mobile_control = load("res://mobile_control.tscn").instantiate()
		control.add_child(mobile_control)
	_show_world()
	start_game()	
	
func configure_game() -> void:
	%World.visible = false	
	Events.dialog_started.emit()
	%Player.visible = false	
	%Tutorial.visible = false	

func start_game() -> void:
	current_body = $World.get_start()
	$Music/BackgroundMusic.play()
	if not State.mobile_control:
		$Tutorial/TutTimer.start()
	start_dialog()

func _dialogue_ended(resource: DialogueResource):
	in_dialog = false
	control.visible = !in_dialog

func _dialogue_started():
	in_dialog = true
	control.visible = !in_dialog

func _dialog_resource() -> DialogueResource:
	return current_body.resource

func _dialog_title() -> String:
	return current_body.title

func mobile_action() -> void:
	var ev = InputEventAction.new()
	ev.pressed = true
	ev.action = "use"
	_input(ev)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use") and not in_dialog:
		current_body = player.get_actionables()
		if current_body:
			start_dialog()
			
		
func start_dialog() -> void:
	Events.dialog_started.emit()
	var resource = _dialog_resource()
	var title = _dialog_title()
	DialogueManager.show_example_dialogue_balloon(resource,title) 

func _can_make_party() -> void:
	current_body = $World.get_party()
	start_dialog()

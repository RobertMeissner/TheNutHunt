extends Area2D

const Balloon = preload("res://res/Dialog/balloon.tscn")

@export var resource: DialogueResource
@export var title: String = "start"

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered",_on_NPC_body_entered)
	connect("area_exited",_on_NPC_body_exited)
	$DialogBubble.visible = active
	
func _on_NPC_body_entered(body: Area2D):
	if body.name == "PlayerFinder":
		$DialogBubble.play()
		active = true
		$DialogBubble.visible = active
	
func _on_NPC_body_exited(body: Area2D):
	if body.name == "PlayerFinder":
		$DialogBubble.stop()
		active = false
		$DialogBubble.visible = active
	

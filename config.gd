extends Control

func _ready() -> void:
	if State.private_version:
		$Label/MyName.text = State.player_name
		$Label2/OtherName.text = State.significant_other_name
		$Label3/Final.text = State.final_words

func _on_start_pressed() -> void:
	State.player_name = $Label/MyName.text
	State.significant_other_name = $Label2/OtherName.text
	if State.private_version:
		State.final_words = State.final_words_private
	# State.final_words = $Label3/Final.text
	Events.game_configured.emit()


func _on_mobile_control_toggled(button_pressed: bool) -> void:
	State.mobile_control = button_pressed

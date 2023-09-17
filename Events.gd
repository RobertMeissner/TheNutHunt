extends Node

signal deactivate
signal activate(body)
signal dialog_started
signal can_search_swimming_googles
signal has_searched_swimming_googles
signal can_find_nuts
signal can_make_party

signal action_button_pressed

signal game_configured

func _emit_search_swimming_googles():
	can_search_swimming_googles.emit()

func _emit_has_searched_swimming_googles():
	has_searched_swimming_googles.emit()

func _emit_can_find_nuts():
	can_find_nuts.emit()

func _emit_can_make_party():
	can_make_party.emit()

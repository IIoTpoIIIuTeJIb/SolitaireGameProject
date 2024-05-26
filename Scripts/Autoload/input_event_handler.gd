extends Node

signal mouse_button_left_down
signal mouse_button_left_up
signal undo
signal restart

func _input(event):
	if event is InputEventMouseButton:	
		if event.button_index == 1 and event.pressed:
			mouse_button_left_down.emit()
	
		if event.button_index == 1 and !event.pressed:
			mouse_button_left_up.emit()
		
	if event.is_action_pressed("ui_undo"):
		undo.emit()
	
	if event.is_action_pressed("game_restart"):
		restart.emit()

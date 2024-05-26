extends Control

func _ready():
	InputEventHandler.connect("restart", _on_game_restart_requested)
	EventBus.emit_signal("game_started")

func _on_game_restart_requested():
	get_tree().change_scene_to_file("res://Scenes/Table.tscn")

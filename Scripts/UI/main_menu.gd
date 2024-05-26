extends Control

@export var player_name_label : Label

@export var start_button : Button
@export var player_button : Button
@export var settings_button : Button
@export var exit_button : Button

@export var game_scene : PackedScene
@export var player_stats_scene : PackedScene
@export var settings_scene : PackedScene

func _ready():
	player_name_label.text = PlayerStats.get_player().name
	
	start_button.connect("pressed", _on_start_pressed)
	player_button.connect("pressed", _on_player_pressed)
	settings_button.connect("pressed", _on_settings_pressed)
	exit_button.connect("pressed", _on_exit_pressed)

func _on_exit_pressed():
	get_tree().quit()

func _on_start_pressed():
	_load_scene(game_scene)
	queue_free()

func _on_player_pressed():
	_load_scene(player_stats_scene)
	queue_free()

func _on_settings_pressed():
	_load_scene(settings_scene)
	queue_free()

func _load_scene(scene : PackedScene):
	get_parent().add_child(scene.instantiate())
	queue_free()

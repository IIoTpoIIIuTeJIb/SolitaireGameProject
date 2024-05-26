extends Control

@export var player_name_edit : LineEdit
@export var player_name_edit_apply_button : Button

@export var games_played_label : Label
@export var games_won_label : Label

@export var back_button : Button

func _ready():
	PlayerStats.connect("player_data_updated", _on_player_stats_updated)
	player_name_edit_apply_button.connect("pressed", _on_player_name_edit_apply)
	back_button.connect("pressed", _on_back_button_pressed)
	player_name_edit.text = PlayerStats.get_player().name
	_update_displayed_stats()

func _on_back_button_pressed():
	get_parent().add_child(load("res://Scenes/UI/menu_container.tscn").instantiate())
	queue_free()

func _on_player_name_edit_apply():
	PlayerStats.change_player(player_name_edit.text)

func _on_player_stats_updated():
	_update_displayed_stats()

func _update_displayed_stats():
	games_played_label.text = str(PlayerStats.get_player().games_played)
	games_won_label.text = str(PlayerStats.get_player().games_won)
	

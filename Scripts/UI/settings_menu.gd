extends Control

@export var back_button : Button
@export var difficulty_list : ItemList

var _difficulty_dict = {
		Settings.SuitsCountMode.one: 0, 
		Settings.SuitsCountMode.two: 1, 
		Settings.SuitsCountMode.four: 2,
	}

func _ready():
	back_button.connect("pressed", _on_back_button_pressed)
	difficulty_list.select(_difficulty_dict.get(Settings.suits))
	difficulty_list.connect("item_clicked", _on_difficulty_selected)

func _on_back_button_pressed():
	queue_free()

func _on_difficulty_selected(index: int, _at_position: Vector2, _mouse_button_index: int):
	Settings.set_difficulty(_difficulty_dict.find_key(index))

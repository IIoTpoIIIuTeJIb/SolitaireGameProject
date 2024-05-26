extends Node

var suits : SuitsCountMode

enum SuitsCountMode {one = 1, two = 2, four = 4}

func _init():
	_read_json()

func _read_json():
	if not FileAccess.file_exists("user://settings.cfg"):
		suits = SuitsCountMode.four
		_write_json()
		return
	
	var parser = JSON.new()
	var file = FileAccess.open("user://settings.cfg", FileAccess.READ)
	var json_line = file.get_line()
	var _parse_result = parser.parse(json_line)
	var data_parsed = parser.get_data()
	suits = data_parsed["difficulty"]

func _write_json():
	var file = FileAccess.open("user://settings.cfg", FileAccess.WRITE)
	var data = {
		"difficulty" = suits
	}
	var data_json = JSON.stringify(data)
	file.store_line(data_json)

func set_difficulty(suits_ : SuitsCountMode):
	suits = suits_
	_write_json()

extends Node

var _player : Player
const address : String = "localhost"

func get_player() -> Player:
	return _player

signal player_data_updated

func _init():
	_load_player_data()
	EventBus.connect("game_ended", _on_game_end)

func _ready():
	_receive_player_data()

func change_player(name_ : String):
	_player = Player.new(name_)
	
	_save_player_data()
	_receive_player_data()

func update_player_data(is_game_won : bool):
	_player.games_played = _player.games_played + 1
	if is_game_won:
		_player.games_won = _player.games_won + 1
	
	_patch_player_data(is_game_won)
	player_data_updated.emit()

func _receive_player_data():
	var requester = HTTPRequest.new()
	add_child(requester)
	requester.connect("request_completed", _on_get_request_completed)
	
	var player_name = _player.name.replace(" ", "_")
	var _error = requester.request(
		"https://" + address + ":7037/PlayerStatistic/GetPlayerStatistic/" + player_name
		,PackedStringArray() ,HTTPClient.METHOD_GET)
	player_data_updated.emit()

func _on_get_request_completed(
	_result : int, 
	_response_code : int, 
	_headers : PackedStringArray, 
	_body : PackedByteArray
	):
		
	print("get result " + str(_result) + " response " + str(_response_code))
	if _response_code == 200:
		var data_decoded = _body.get_string_from_utf8()
		var parser = JSON.new()
		var _parse_result = parser.parse(str(data_decoded), true)
		var data_parsed = parser.get_data()
		_player.games_played = data_parsed["gamesPlayed"]
		_player.games_won = data_parsed["gamesWon"]

func _patch_player_data(is_game_won : bool):
	var requester = HTTPRequest.new()
	add_child(requester)
	var data = {
		"GameName" = "SpiderSolitaire",
		"PlayerName" = _player.name,
		"IsWin" = is_game_won
	}
	var body = JSON.stringify(data)
	var _error = requester.request(
		"https://" + address + ":7037/PlayerStatistic/UpdatePlayersStatistic"
		,PackedStringArray() ,HTTPClient.METHOD_PATCH, body)
	print("update request " + str(_error))

func _load_player_data():
	if not FileAccess.file_exists("user://user.save"):
		_player = Player.new("Player 1") #placeholder TODO: запросить ввод имени игроком
		_save_player_data()
		return
	
	var parser = JSON.new()
	var file = FileAccess.open("user://user.save", FileAccess.READ)
	var json_line = file.get_line()
	var _parse_result = parser.parse(json_line)
	var data_parsed = parser.get_data()
	
	_player = Player.new(data_parsed["player_name"])

func _save_player_data():
	var file = FileAccess.open("user://user.save", FileAccess.WRITE)
	var data = {
		"player_name" = _player.name
	}
	var data_json = JSON.stringify(data)
	file.store_line(data_json)

func _on_game_end(is_game_won : bool):
	PlayerStats.update_player_data(is_game_won)

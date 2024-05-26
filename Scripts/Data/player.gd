extends Object
class_name Player

var name : String
var games_played : int = 0
var games_won : int = 0

func get_winrate() -> float:
	if games_played < 1:
		return 0
	if games_won < 1:
		return 0
	return float(games_won) / float(games_played)

func get_winrate_percent() -> float:
	return get_winrate() * 100

func _init(name_ : String):
	name = name_

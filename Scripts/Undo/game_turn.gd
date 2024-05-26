extends Object
class_name GameTurn

var _commands : Array

func undo():
	for command in _commands:
		command.undo()

func set_commands(commands : Array) -> GameTurn:
	_commands = commands
	return self

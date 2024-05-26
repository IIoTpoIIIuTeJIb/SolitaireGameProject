extends Node
class_name GameTurnManager

static var instance

var _turns : Array
var _commands : Array

signal turn_undone

func _ready():
	instance = self
	InputEventHandler.connect("undo", _on_undo)


func _on_undo():
	_undo_turn()


func _undo_turn():
	stop_recording()
#	print("undoing turn")
	if _turns.size() > 0:
		_turns.pop_back().undo()
	emit_signal("turn_undone")


func execute_command(command : Command):
	command.execute()
	_record_command(command)


func stop_recording():
	if _commands.size() > 0:
		_save_turn()


func _record_command(command : Command):
	_commands.append(command)


func _save_turn():
	var turn = GameTurn.new().set_commands(_commands.duplicate())
	_turns.append(turn)
	_commands.clear()


func clear_commands():
	_turns.clear()

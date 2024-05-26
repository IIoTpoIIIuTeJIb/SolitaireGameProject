extends Command
class_name Command_AssemblePile

func execute():
	pass


func undo():
	EventBus.emit_signal("assembled_pile_undone")

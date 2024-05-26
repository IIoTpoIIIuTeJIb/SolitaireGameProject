extends Command
class_name Command_RemovePile

var cards : Array = []
var origin : Control


func _init(cards_ : Array, origin_ : Control):
	cards = cards_.duplicate()
	origin = origin_


func execute():
	pass


func undo():
	for _card in cards:
		if _card.get_parent():
				_card.reparent(origin)
		else:
			origin.add_child(_card)

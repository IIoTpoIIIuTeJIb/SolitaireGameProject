extends Command
class_name Command_MoveCard

var card : CardDragable
var origin : Pile


func _init(card_ : CardDragable, origin_ : Pile):
	card = card_
	origin = origin_


func execute():
	pass

func undo():
	if card.get_parent():
			card.reparent(origin)
	else:
		origin.add_child(card)

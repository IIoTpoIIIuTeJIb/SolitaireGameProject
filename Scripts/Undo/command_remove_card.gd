extends Command
class_name Command_RemoveCard

var card
var origin


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

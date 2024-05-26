extends Command
class_name Command_FlipCard

var card : CardDragable


func _init(card_ : CardDragable):
	card = card_


func execute():
	card.set_isOpen(!card.isOpen)

func undo():
	card.set_isOpen(!card.isOpen)

extends Command
class_name Command_InstantiateCard

var card_instance : CardDragable


func _init(card_ : CardDragable):
	card_instance = card_


func execute():
	pass

func undo():
	var card = {suit = card_instance.suit, rank = card_instance.rank}
	GameStateManager.instance.undone_stock.append(card)
	card_instance.queue_free()

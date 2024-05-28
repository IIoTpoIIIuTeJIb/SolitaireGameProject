extends Control
class_name Pile

const cardResource = "res://Scenes/GameObjects/CardDragable.tscn"
var cardPreload = preload(cardResource)

@export var startingCards : int = 0

func _ready():
	EventBus.CardsDealt.connect(_on_cards_dealt)
	for i in range(0, startingCards):
		_instantiate_card()
	if get_child_count() > 0:
		get_children().back().flip()

func _can_drop_data(_at_position, _data):
	if !_data["is_draggable"]:
		return false
	if !_data["cards"]:
		return false
	if _data["cards"].front().is_same_suit_descending():
		return true
	return false


func _drop_data(_at_position, _data):
	drop_cards(_data.cards, _data)


func drop_cards(_cards, _data):
	var commands = []
	
	for _card in _cards:
		commands.append(Command_MoveCard.new(_card, _card.get_parent()))
		move_card(_card)


	for command in commands:
		GameTurnManager.instance.execute_command(command)
		
	EventBus.CardMoved.emit()
		
	if _is_pile_assembled():
		var _pile = get_assembled_pile()
		for _card in _cards:
			_pile.pop_back()
		_remove_cards(_pile)


func _is_pile_assembled() -> bool:
	var cardsCount = get_child_count() - 1
	
	if cardsCount < 13:
		return false
	
	if get_child(-13).is_same_suit_descending():
		return true
	
	return false


func _remove_assmebled_pile():
	if !_is_pile_assembled():
		return
	var cardsCount = get_child_count() - 1
	
	var suit = get_child(-13).suit
	var cards = []
	for i in range(cardsCount, cardsCount - 13, -1):
		var card = get_child(i)
		cards.append(card)
		remove_child(card)
	cards.reverse()
	var command = Command_RemovePile.new(cards, self)
	GameTurnManager.instance.execute_command(command)
	EventBus.emit_signal("cards_assmebled", suit)


func get_assembled_pile() -> Array:
	var cardsCount = get_child_count() - 1
	var _pile = []
	for i in range(cardsCount, cardsCount - 13, -1):
		var card = get_child(i)
		_pile.append(card)
	return _pile


func _remove_cards(_cards : Array):
	if !_cards:
		return
	var suit = _cards.front().suit
#	var cardsCount = get_child_count() - 1
	var cards = []
	_cards.reverse()
	for _card in _cards:
		cards.append(_card)
		remove_child(_card)
	cards.reverse()
	var command = Command_RemovePile.new(cards, self)
	GameTurnManager.instance.execute_command(command)
	EventBus.CardsAssembled.emit(Card.Suit.find_key(suit))#_signal("cards_assmebled", suit)


func _on_cards_dealt():
	var instance = _instantiate_card()
	GameTurnManager.instance.execute_command(Command_InstantiateCard.new(instance))
	EventBus.CardMoved.emit()


func _instantiate_card() -> Node:
	var instance = cardPreload.instantiate()
	add_child(instance)
	_remove_assmebled_pile()
	return instance


func move_card(card : Control):
	card.reparent(self)
	_remove_assmebled_pile()

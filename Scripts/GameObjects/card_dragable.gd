extends Button
class_name CardDragable

var suit = Card.Suit.spades
var rank = Card.Rank.ace
var isOpen : bool = false

@onready var _animSprite = %AnimatedSprite2D

func set_isOpen(value : bool):
	isOpen = value
	flip()

func _ready():
	EventBus.connect("game_started", _on_game_started)
	EventBus.connect("card_moved", _on_card_moved)
	_pop_card_from_deck()


func _on_game_started():
	refresh()


func _on_card_moved():
	if _is_last_card():
		if !isOpen:
			GameTurnManager.instance.execute_command(Command_FlipCard.new(self))
			set_isOpen(true)


func refresh():
	if !isOpen:
		_animSprite.play("back")
		return
	if !rank:
		_animSprite.play("_empty")
		return
	if !suit:
		_animSprite.play("_empty")
		return
	if suit == Card.Suit.empty:
		_animSprite.play("_empty")
		return
	var suit_name = Card.Suit.find_key(suit)
	var rank_name = Card.Rank.find_key(rank)
	var anim = suit_name + rank_name
	_animSprite.play(anim)


func _pop_card_from_deck():
	var card = GameStateManager.instance.deck.pop_back()
	suit = card["suit"]
	rank = card["rank"]


func _get_drag_data(_at_position):
	GameTurnManager.instance.stop_recording()
	var data = {}
	data["is_draggable"] = _is_dragable()
	data["origin_node"] = self
	data["origin_parent"] = get_parent().get_parent()
	
	var cards = []
	for i in range(get_index(), get_parent().get_child_count()):
		cards.append(get_parent().get_child(i))
	data["cards"] = cards
#	TO DO: drag preview
	return data

func _is_dragable() -> bool:
	if isOpen and (_is_last_card() or is_same_suit_descending()):
		return true
	return false


func is_same_suit_descending() -> bool:
	if _is_last_card():
		return true
	for i in range(get_index() + 1, get_parent().get_child_count()):
		if !(get_parent().get_child(i).rank == get_parent().get_child(i - 1).rank - 1 and get_parent().get_child(i - 1).suit == get_parent().get_child(i).suit):
			return false
	return true


func _is_last_card() -> bool:
	if !get_parent() or !get_parent().get_child_count() > 0:
		return false
	if get_index() == get_parent().get_child_count() - 1:
		return true
	return false


func _can_drop_data(_at_position, _data) -> bool:
	if !isOpen:
		return false
	if !_is_last_card():
		return false
	if !_data["is_draggable"]:
		return false
	if  !_data["cards"]:
		return false
	if  _data["cards"].front().rank == rank - 1:
		return true
	return false

func _drop_data(_at_position, _data):
#	GameTurnManager.stop_recording()
	var parentNode : Pile = self.get_parent()
	parentNode.drop_cards(_data.cards, _data)
#	for _card in _data.cards:
#		var command = Command_MoveCard.new_command(_card, _card.get_parent())
#		GameTurnManager.execute_command(command)
#		parentNode.move_card(_card)


func _pressed():
	flip()

func flip():
	if !isOpen and _is_last_card():
		isOpen = true
	refresh()

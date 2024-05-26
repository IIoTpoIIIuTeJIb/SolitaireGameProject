extends Control

#var card: Card = Card.new()
var rank : Card.Rank = Card.Rank.empty
var suit : Card.Suit = Card.Suit.empty

@onready var _animSprite = $AnimatedSprite2D

#func _ready():
#	refresh()


func refresh():
	if suit == Card.Suit.empty:
		print(_animSprite)
		_animSprite.play("_empty)")
		return
	var suit_name = Card.Suit.find_key(suit)
	var rank_name = Card.Rank.find_key(rank)
	var anim = suit_name + rank_name
	_animSprite.play(anim)


func set_card_data(_rank : Card.Rank, _suit : Card.Suit):
	suit = _suit
	rank = _rank
	refresh()

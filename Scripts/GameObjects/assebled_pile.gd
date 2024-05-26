extends Control

const cardResource = "res://Scenes/GameObjects/CardView.tscn"

var card = preload(cardResource)

func _ready():
	EventBus.connect("cards_assmebled", _on_cards_assembled)
	EventBus.connect("assembled_pile_undone", _on_assembled_pile_undone)

func _on_assembled_pile_undone():
	get_children().front().queue_free()

func _on_cards_assembled(_suit: Card.Suit):
	GameTurnManager.instance.execute_command(Command_AssemblePile.new())
	var instance = card.instantiate()
	add_child(instance)
	var rank = Card.Rank.king
	var suit = _suit
	instance.set_card_data(rank, suit)

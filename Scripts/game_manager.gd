extends Node
class_name GameStateManager

static var instance

@export var exit_button : Button
@export var restart_button : Button
@export var undo_button : Button

var decks : int = 2
var suits : Settings.SuitsCountMode
var is_game_started : bool = false
var is_game_won : bool = false
var piles_assembled : int = 0

var deck = []

var undone_stock = []

func _init():
	suits = Settings.suits
	instance = self
	_create_deck()

func _ready():
	is_game_started = true
	
	EventBus.connect("cards_assmebled", _on_pile_assembled)
	EventBus.connect("assembled_pile_undone", _on_assembled_pile_undone)
	GameTurnManager.instance.connect("turn_undone", _on_turn_undone)
	InputEventHandler.connect("restart", _on_game_restart)
	
	exit_button.connect("pressed", _on_exit_pressed)
	restart_button.connect("pressed", _on_game_restart)
	undo_button.connect("pressed", _on_undo_pressed)
	
	EventBus.emit_signal("game_started")

func _on_pile_assembled(_suit : Card.Suit):
	piles_assembled = piles_assembled + 1
	if piles_assembled == decks * 4:
		is_game_won = true
		GameTurnManager.instance.clear_commands()

func _on_assembled_pile_undone():
	piles_assembled = piles_assembled - 1

func _on_game_restart():
	get_parent().add_child(load("res://Scenes/Games/spider_game_container.tscn").instantiate())
	EventBus.emit_signal("game_ended", is_game_won)
	queue_free()

func _on_undo_pressed():
	InputEventHandler.emit_signal("undo")

func _on_turn_undone():
	undone_stock.reverse()
	deck.append_array(undone_stock)
	undone_stock.clear()

func _create_deck():
	if !decks > 0:
		return
	match (suits):
		Settings.SuitsCountMode.one:
			for deckN in range(0, decks):
				for suitN in range(1, 5):
					for rankN in range(1, 14):
						var card = {suit = Card.Suit.spades, rank = rankN}
						deck.append(card)
		
		Settings.SuitsCountMode.two:
			for deckN in range(0, decks * 2):
				for suitN in range(1, 3):
					for rankN in range(1, 14):
						var card = {suit = suitN, rank = rankN}
						deck.append(card)
		
		Settings.SuitsCountMode.four:
			for deckN in range(0, decks):
				for suitN in range(1, 5):
					for rankN in range(1, 14):
						var card = {suit = suitN, rank = rankN}
						deck.append(card)
	deck.shuffle()
	deck.shuffle()
	deck.shuffle()
	deck.shuffle()
	deck.shuffle()

func _on_exit_pressed():
	EventBus.emit_signal("game_ended", is_game_won)
	var scene = load("res://Scenes/UI/menu_container.tscn").instantiate()
	get_parent().add_child(scene)
	queue_free()

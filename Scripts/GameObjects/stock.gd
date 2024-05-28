extends Button

func _pressed():
	GameTurnManager.instance.stop_recording()
	var command = Command_DealCards.new(self.get_parent())
	GameTurnManager.instance.execute_command(command)
	EventBus.CardsDealt.emit()#.emit_signal("cards_dealt")
	get_parent().remove_child(self)
	self.queue_free()

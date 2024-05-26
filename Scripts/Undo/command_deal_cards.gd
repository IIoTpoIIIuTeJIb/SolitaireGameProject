extends Command
class_name Command_DealCards

var stock


func _init(stock_):
	stock = stock_


func execute():
	pass

func undo():
	stock.spawn()

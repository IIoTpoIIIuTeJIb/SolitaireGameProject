extends HBoxContainer
class_name Stock_Spawner

const stockResource = "res://Scenes/GameObjects/Stock.tscn"

var stock = preload(stockResource)

@export var count : int = 5

func _ready():
	_spawn()
	
func _spawn():
	if !count > 0:
		return
	for i in range(0, count):
		var instace = stock.instantiate()
		add_child(instace)


func spawn():
	var instace = stock.instantiate()
	add_child(instace)

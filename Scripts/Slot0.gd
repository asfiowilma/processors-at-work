extends Position2D

enum CONTENT{EMPTY, FOOD, COFFEE}

var content = CONTENT.EMPTY
var food = load("res://Scenes/Items/Food.tscn")
var coffee = load("res://Scenes/Items/Coffee.tscn")

func _ready():
	empty()

func empty():
	for n in get_children():
		remove_child(n)
		n.queue_free()
	
func has_food():
	add_child(food.instance())
	
func has_coffee():
	add_child(coffee.instance())
	

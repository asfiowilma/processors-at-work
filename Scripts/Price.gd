extends Label

export(int) var price

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(price) + " bits"

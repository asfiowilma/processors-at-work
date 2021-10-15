extends CanvasItem

signal close_shop
signal buy_food
signal buy_coffee

onready var food_price = $ShopPanel/Control/Food/Price.price
onready var coffee_price = $ShopPanel/Control/Coffee/Price.price

func _process(delta):
	$ShopPanel/Cash.text = "Cash: " + str(Globals.cash) + " bits"
	check_inventory()
	
	if Input.is_key_pressed(KEY_ESCAPE):
		close_shop()
	elif Input.is_action_just_pressed("buy_food"):
		buy_food()
	elif Input.is_action_just_pressed("buy_coffee"):
		buy_coffee()

func check_inventory():
	var food_button = $ShopPanel/Control/Food/BuyFood
	var coffee_button = $ShopPanel/Control/Coffee/BuyCoffee
	food_button.disabled = false
	coffee_button.disabled = false
	
	if Globals.cash < food_price:
		food_button.disabled = true
	if Globals.cash < coffee_price:
		coffee_button.disabled = true
	
	if Globals.empty_slots == 0:
		food_button.disabled = true
		coffee_button.disabled = true

func buy_food():
	$Purchase.play()	
	if Globals.empty_slots > 0 and Globals.cash >= food_price:
		emit_signal("buy_food")
		Globals.cash -= food_price
			
func buy_coffee():
	if Globals.empty_slots > 0 and Globals.cash >= coffee_price:
		$Purchase.play()
		emit_signal("buy_coffee")
		Globals.cash -= coffee_price

func close_shop():
	emit_signal("close_shop")
	Globals.is_shop_open = false

func _on_CloseButton_pressed():
	close_shop()

func _on_BuyFood_pressed():
	buy_food()

func _on_BuyCoffee_pressed():
	buy_coffee()

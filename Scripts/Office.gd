extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal grab_task

onready var scoreLabel = $TopBar/ColorRect/HBoxContainer/ScoreLabel
onready var cashLabel = $TopBar/ColorRect/HBoxContainer/CashLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	$ShopLayer/ShopMenu.hide()
	for slot in $Inventory.get_children(): 
		Globals.inventory.append(slot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scoreLabel.text = "Score: " + str(Globals.score)
	cashLabel.text = "Cash: " + str(Globals.cash) + " bits"

func _on_MenuBtn_pressed():
	Globals.reset_game()
	$ConfirmSound.play()
	$Transition.layer = 5
	$Transition/ColorRect/AnimationPlayer.play_backwards("transition")

func _on_ControlU_open_shop():
	$ShopLayer/ShopMenu.show()


func _on_ShopMenu_close_shop():
	$ShopLayer/ShopMenu.hide()


func _on_ShopMenu_buy_coffee():
	for slot in Globals.inventory:
		if slot.content == slot.CONTENT.EMPTY:
			slot.content = slot.CONTENT.COFFEE
			slot.has_coffee()
			Globals.empty_slots -= 1
			break

func _on_ShopMenu_buy_food():
	for slot in Globals.inventory:
		if is_instance_valid(slot) and slot.content == slot.CONTENT.EMPTY:
			slot.content = slot.CONTENT.FOOD
			slot.has_food()
			Globals.empty_slots -= 1
			break


func _on_ControlU_grab_task():
	emit_signal("grab_task")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

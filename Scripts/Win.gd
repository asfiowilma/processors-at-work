extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t_start = true
var btn = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition.layer = 5
	$Transition/ColorRect/AnimationPlayer.play("transition")
	t_start = true
	
	$VBoxContainer/ScoreLabel.text = "Score: " + str(Globals.score)
	$VBoxContainer/RemainingCash.text = "Remaining Cash: " + str(Globals.cash) + " bits"
	
	if Globals.next_level_scene == null:
		$Button2.disabled = true


func _on_Button_pressed():
	$Transition.layer = 5
	$Transition/ColorRect.show()
	$Transition/ColorRect/AnimationPlayer.play_backwards("transition")
	t_start = false
	btn = 'menu'

func _on_AnimationPlayer_animation_finished(anim_name):
	if t_start:
		$Transition.layer = -1
		$Transition/ColorRect.hide()
	else:
		print('test')
		if btn == 'menu':
			Globals.reset_game()
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
		elif btn == 'next':
			print(Globals.next_level_scene)
			get_tree().change_scene(Globals.next_level_scene)
			

func _on_Button2_pressed():
	btn = 'next'
	t_start = false	
	print(btn)
	$Transition.layer = 5
	$Transition/ColorRect.show()
	$Transition/ColorRect/AnimationPlayer.play_backwards("transition")

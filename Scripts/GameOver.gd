extends TextureRect

var t_start = true

func _ready():
	$Transition.layer = 5
	$Transition/ColorRect.color = Color8(84, 36, 55)
	t_start = true
	$Transition/ColorRect/AnimationPlayer.play("transition")
	$GameOverMessage.text = Globals.game_over_message

func _on_Button_pressed():
	$ConfirmSound.play()
	t_start = false
	$Transition.layer = 5
	$Transition/ColorRect.color = Color8(84, 36, 55)
	$Transition/ColorRect/AnimationPlayer.play_backwards("transition")


func _on_AnimationPlayer_animation_finished(anim_name):
	if t_start:
		$Transition.layer = -1
		$Transition/ColorRect.hide()
	else:
		Globals.reset_game()
		get_tree().change_scene("res://Scenes/MainMenu.tscn")

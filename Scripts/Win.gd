extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t_start = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition.layer = 5
	$Transition/ColorRect/AnimationPlayer.play("transition")
	t_start = true
	
	$VBoxContainer/ScoreLabel.text = "Score: " + str(Globals.score)
	$VBoxContainer/RemainingCash.text = "Remaining Cash: " + str(Globals.cash) + " bits"


func _on_Button_pressed():
	$Transition.layer = 5
	$Transition/ColorRect.show()
	$Transition/ColorRect/AnimationPlayer.play_backwards("transition")
	t_start = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if t_start:
		$Transition.layer = -1
		$Transition/ColorRect.hide()
	else:
		get_tree().change_scene("res://Scenes/MainMenu.tscn")

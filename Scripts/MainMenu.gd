extends CanvasLayer

onready var transition = $Transition/ColorRect/AnimationPlayer
var t_start = true 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition.layer = 5
	transition.play("transition")
	t_start = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not transition.is_playing() and Input.is_action_just_pressed("play"):
		t_start = false
		$Transition.layer = 5
		transition.play_backwards("transition")

func _on_PlayBtn_pressed():
	$ConfirmSound.play()	
	$Transition.layer = 5
	transition.play_backwards("transition")
	t_start = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if !t_start:
		get_tree().change_scene("res://Scenes/Level1.tscn")
	else:
		$Transition.layer = -1
		$Transition/ColorRect.hide()
		
func _on_CreditBtn_pressed():
	$ConfirmSound.play()
	$Credits/Popup.popup()
	$Credits/ColorRect.visible = true

func _on_Popup_popup_hide():
	$Credits/ColorRect.visible = false
	$Manuals/ColorRect.visible = false

func _on_ManualBtn_pressed():
	$Manuals/Popup.popup()
	$Manuals/ColorRect.visible = true

func _on_CloseButton_pressed():
	$Manuals/Popup.hide()

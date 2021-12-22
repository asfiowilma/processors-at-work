extends Node2D

var tasks = []
var isWon = false
var t_start = true 

onready var timerLabel = $Office/TopBar/ColorRect/HBoxContainer/TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition.layer = 5
	$Transition/ColorRect/AnimationPlayer.play("transition")
	
	$Office/TopBar/ColorRect/HBoxContainer/LevelLabel.text = "Level 01"
	
	for task_code in Globals.level_1: 
		tasks.append(Globals.generate_task(task_code))
	
	var task = tasks.pop_front()
	Globals.tasks.append(task)
	$Table.add_child(task)
	reposition_tasks()
	
	$LevelTimer.wait_time = len(tasks) * 5 + 10
	timerLabel.text = str($LevelTimer.wait_time)
	$LevelTimer.start()

func _process(delta):
	timerLabel.text = str(int($LevelTimer.time_left))
	check_win_condition()

func reposition_tasks():
	if len(Globals.tasks) > 0 and is_instance_valid(Globals.tasks[0]):
		$Table/task0.add_child(Globals.tasks[0])
		Globals.tasks[0].global_position = $Table/task0.global_position
	if len(Globals.tasks) > 1 and is_instance_valid(Globals.tasks[1]):
		$Table/task1.add_child(Globals.tasks[1])
		Globals.tasks[1].global_position = $Table/task1.global_position
	if len(Globals.tasks) > 2 and is_instance_valid(Globals.tasks[2]):
		$Table/task2.add_child(Globals.tasks[2])
		Globals.tasks[2].global_position = $Table/task2.global_position
	if len(Globals.tasks) > 3 and is_instance_valid(Globals.tasks[3]):
		$Table/task3.add_child(Globals.tasks[3])
		Globals.tasks[3].global_position = $Table/task3.global_position

func check_win_condition():
	if not $BufferTimer.is_stopped():
		return
		
	var processors = get_tree().get_nodes_in_group("processors")
	var remaining_tasks = get_tree().get_nodes_in_group("tasks")
	if processors.size() == 0:
		Globals.game_over_message = 'Everyone exploded!'
		$BufferTimer.start()
		return
	elif $LevelTimer.is_stopped() \
		and (len(Globals.tasks) > 0 or remaining_tasks.size() > 0):
		Globals.game_over_message = 'You ran out of time!'
		$BufferTimer.start()
		return
	elif len(tasks) == 0 \
		and len(Globals.tasks) == 0 \
		and remaining_tasks.size() == 0:
		isWon = true
		for processor in processors:
			processor.get_node("AnimatedSprite").frames.set_animation_loop("happy", true)
			processor.get_node("AnimatedSprite").play("happy")
		$BufferTimer.start()
		return		

func _on_TaskTimer_timeout():
	if len(tasks) > 0:
		var task = tasks.pop_front()
		Globals.tasks.append(task)
		$Table.add_child(task)
		reposition_tasks()

func _on_Office_grab_task():
	reposition_tasks()

func _on_LevelTimer_timeout():
	check_win_condition()

func _on_BufferTimer_timeout():
	if !isWon:
		$Transition/ColorRect.color = Color8(84, 36, 55)
	$Transition.layer = 5
	$Transition/ColorRect.show()
	$Transition/ColorRect/AnimationPlayer.play_backwards("transition")		
	t_start = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if t_start: 
		$Transition.layer = -1
		$Transition/ColorRect.hide()
	else:
		if isWon:
			get_tree().change_scene("res://Scenes/Win.tscn")
		else:
			$Transition/ColorRect.color = Color("#")
			get_tree().change_scene("res://Scenes/GameOver.tscn")

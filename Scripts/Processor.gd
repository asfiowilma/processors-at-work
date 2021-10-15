extends StaticBody2D

enum STATE{
	idle,
	overheat,
	toasted
}
enum NAME{
	ainun,
	intan,
	raden,
	anthony
}

export(NAME) var character

onready var sprite = $AnimatedSprite
onready var taskTimer = $TaskTimer
export var state = STATE.idle
var toasted = false

var heat = 0
var warmup = 12
var cooldown = 2
var isWorking = false
var hugeTaskCost = 5
var smolTaskCost = 3

var todos = []

var ITEM = preload("res://Scripts/Items.gd")
var AINUN = preload("res://Assets/Characters/Ainun.tres")
var RADEN = preload("res://Assets/Characters/Raden.tres")
var INTAN = preload("res://Assets/Characters/Intan.tres")
var ANTHONY = preload("res://Assets/Characters/Anthony.tres")

func check_todos():
	return todos[0].task != null

func update_state():
	if heat >= 100:
		state = STATE.toasted
		$ToastedSound.play()
	elif heat >= 80:
		state = STATE.overheat
		if !$StressSound.is_playing():
			$StressSound.play()
	else:
		state = STATE.idle

func animate_sprite():
	sprite.stop()
	if state == STATE.idle:
		sprite.play("default")
		if $StressSound.is_playing():
			$StressSound.stop()
	elif state == STATE.overheat:
		sprite.play("angry")		

func consume_item(item):
	if item.type == ITEM.TYPE.FOOD: 
		print("food consumed")
		heat -= 32
		$HeatMeter.value = heat
	elif item.type == ITEM.TYPE.COFFEE:
		warmup = warmup/2
		sprite.frames.set_animation_speed("stressed", 4)
		print("coffee boost starts")
		$HeatTimer.wait_time = 0.6
		$BoostTimer.start()
	sprite.play("happy")
	item.queue_free()
	update_state()
	animate_sprite()

func poll_todos():
	# remove done task
	var done = todos[0]
	done.isOnProgress = false
	if todos[2].task != null and todos[1].task != null:
		todos[2].task.global_position = todos[1].task.global_position
	if todos[1].task != null:
		todos[1].task.global_position = done.task.global_position
	done.task.queue_free()

	# shift todos
	done.task = todos[1].task
	todos[1].task = todos[2].task
	todos[2].task = null

func _process(delta):
	if state == STATE.toasted:		
		sprite.play("toasted")
		remove_from_group("processors")
		for todo in todos:
			if is_instance_valid(todo):
				todo.isOnProgress = false
				if is_instance_valid(todo.task):
					todo.task.isGrabbed = false
		for child in get_children():
			if child.get_class() != "AnimatedSprite" \
				and child.get_class() != "CollisionShape2D" \
				and child != $ToastedSound:
				child.queue_free()
		return 
		
	elif taskTimer.is_stopped() and check_todos():
		isWorking = true 
		sprite.play("stressed")
		print("Starting work")
		todos[0].isOnProgress = true
		var size = todos[0].task.size
		if size == todos[0].task.SIZE.SMOL:
			taskTimer.wait_time = smolTaskCost
		else:
			taskTimer.wait_time = hugeTaskCost
		taskTimer.start()
	
func _ready():
	if character == NAME.ainun:
		sprite.set_sprite_frames(AINUN)
		hugeTaskCost = 4
	elif character == NAME.raden:
		sprite.set_sprite_frames(RADEN)
		warmup = 10
		hugeTaskCost = 6
	elif character == NAME.intan:
		sprite.set_sprite_frames(INTAN)
	elif character == NAME.anthony:
		sprite.set_sprite_frames(ANTHONY)
		cooldown = 3
		smolTaskCost = 4
	$HeatMeter.hide()
	for i in get_children():
		if i.is_in_group("todo"):
			todos.append(i)

func _on_TaskTimer_timeout():	
	isWorking = false
	print("Finished work")
	
	var done = todos[0].task
	Globals.score += done.score_value + warmup + hugeTaskCost
	Globals.cash += done.cash_value
	
	$WorkDoneSound.play()	
	poll_todos()
	update_state()
	animate_sprite()

func _on_HeatTimer_timeout():
	if isWorking and heat < 100:
		heat += warmup
	elif not isWorking and heat > 0: 
		heat -= cooldown
		
	if heat < 0:
		heat = 0
	
	update_state()
	$HeatMeter.value = heat
	if heat > 0:
		$HeatMeter.show()
	else:
		$HeatMeter.hide()

func _on_BoostTimer_timeout():
	sprite.frames.set_animation_speed("stressed", 2)
	print("coffee boost ends")
	warmup *= 2
	$HeatTimer.wait_time = 1

extends KinematicBody2D

signal open_shop
signal grab_task

export var speed = 200  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window. 
var carry

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if !Globals.is_shop_open: 
		if Input.is_action_pressed("right"):
			velocity.x += 1
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		
	if Input.is_action_just_pressed("interact"):
		print(carry)
		for body in $Reachable.get_overlapping_bodies():
			if body.is_in_group("shop_counter"):
				print("in shop")
				Globals.is_shop_open = true
				emit_signal("open_shop")
			elif not is_instance_valid(carry):
				if body.is_in_group("tasks") and not body.isGrabbed:
					carry = body
					Globals.tasks.erase(body)
					emit_signal("grab_task")
					carry.isGrabbed = true
					break
				elif body.is_in_group("items"):
					carry = body
					break
			elif is_instance_valid(carry):
				if body.is_in_group("processors"):
					if carry.is_in_group("tasks"):
						for i in range(len(body.todos)):
							var todo = body.todos[i]
							if todo != null and todo.task == null and not todo.isOnProgress:
								carry.global_position = todo.global_position
								todo.task = carry
								carry = null 
								break
					elif carry.is_in_group("items"):
						var item = carry
						item.get_parent().content = item.get_parent().CONTENT.EMPTY
						carry = null
						body.consume_item(item)
	velocity = velocity.normalized() * speed

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	position += velocity * delta
	position.x = clamp(position.x, 16, screen_size.x-16)
	position.y = clamp(position.y, 16, screen_size.y-16)
	
	if is_instance_valid(carry):
		carry.global_position = $Carrying.global_position


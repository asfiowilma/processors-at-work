extends StaticBody2D

enum SIZE{SMOL,HUGE}
enum COLOR{RED, GREEN, BLUE}

var isGrabbed = false
export(COLOR) var color

func render_color():
	if color == COLOR.RED:
		$Sprite.play("red")
	elif color == COLOR.GREEN:
		$Sprite.play("green")
	elif color == COLOR.BLUE:
		$Sprite.play("blue")

extends Node

var score = 0
var cash = 0 
var is_shop_open = false
var game_over_message = ''
var next_level_scene = null

var tasks = []
var inventory = []
var empty_slots = 4

var HUGETASK = preload("res://Scenes/Tasks/HugeTask.tscn")
var SMOLTASK = preload("res://Scenes/Tasks/SmolTask.tscn")

# LEVELS 
var level_1 = ['sr', 'sb', 'sr', 'sg', 'hr']
var level_2 = ['sg', 'hb', 'sr', 'hg', 'hr', 'sg', 'hg']

func reset_game(): 
	score = 0
	cash = 0
	is_shop_open = false
	tasks = []
	inventory = []
	empty_slots = 4

func generate_task(code):
	var huge = HUGETASK.instance()
	var smol = SMOLTASK.instance()
	huge.global_position = Vector2(-4000, -4000)
	smol.global_position = Vector2(-4000, -4000)
	if code == 'hg':
		huge.color = huge.COLOR.GREEN
		return huge
	elif code == 'sg':
		smol.color = smol.COLOR.GREEN
		return smol
	elif code == 'hb':
		huge.color = huge.COLOR.BLUE
		return huge
	elif code == 'sb':
		smol.color = smol.COLOR.BLUE
		return smol
	elif code == 'hr':
		huge.color = huge.COLOR.RED
		return huge
	elif code == 'sr':
		smol.color = smol.COLOR.RED
		return smol

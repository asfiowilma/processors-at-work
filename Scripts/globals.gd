extends Node

var score = 0
var cash = 0 
var is_shop_open = false

var tasks = []
var inventory = []
var empty_slots = 4

func reset_game(): 
	score = 0
	cash = 0
	is_shop_open = false
	tasks = []
	inventory = []
	empty_slots = 4

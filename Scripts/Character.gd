extends Node2D

class_name  Character

@export var start_money : int = 100

var player_money: int
var monster_money: int

var p_guess: int = 1
var m_guess: int = 2

var p_bet: int 
var m_bet: int

# argument is {"min": intValue, "max": intValue}
func com_bet(optional: Dictionary, current_value: int) -> int:
	var minOption = optional["min"]
	var midOption = optional["mid"]
	var maxOption = optional["max"]
	
	# requred! {"min", "mid", "max"}
	if(!minOption or !maxOption or !midOption):
		printerr("optional variable is not full filled.")
	
	if(current_value > maxOption):
		monster_money -= maxOption
		return maxOption

	elif ( current_value > midOption):
		monster_money -= midOption
		return midOption

	elif ( current_value > minOption):
		monster_money -= minOption
		return minOption

	else:
		return current_value

func _ready():
	_setup()

func _setup():
	player_money = start_money
	monster_money = start_money

func player_get_money(amount: int):
	player_money += amount

func monster_get_money(amount: int):
	monster_money += amount

func someIsZero() -> String:
	if(player_money < 1):
		return 'p'
	elif(monster_money < 1):
		return 'm'
	
	return 'n'


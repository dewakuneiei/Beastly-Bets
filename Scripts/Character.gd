extends Node2D

class_name  Character

@export var start_money : int = 300

var player_money: int
var monster_money: int

var p_guess: int = 1
var m_guess: int = 2

var p_bet: int 
var m_bet: int

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


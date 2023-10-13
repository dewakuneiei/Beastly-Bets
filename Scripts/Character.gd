extends Node2D

class_name  Character

@export var start_money : int = 100

var player_money: int
var monster_money: int

func _ready():
	_setup()

func _setup():
	player_money = start_money
	monster_money = start_money

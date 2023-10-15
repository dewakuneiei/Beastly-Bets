extends MarginContainer

class_name PlayerInput

@onready var left_btn := %left
@onready var right_btn := %right
@onready var sight_l := %sight
@onready var amount := %amount

var maxBet : int = 100
var minBet : int = 1

var game: Game
var character: Character

var _number_input: int = 1:
	set(newValue):
		_number_input = newValue 
		sight_l.text = str(_number_input)

var _bet_amount: int = 10:
	set(newValue):
		_bet_amount = newValue
		amount.text = str(_bet_amount)




func _ready():
	sight_l.text = str(_number_input)
	amount.text = str(_bet_amount)

func _process(delta):
	if( !character ):
		printerr("something wrong with character")
	maxBet = character.player_money


func _reset_defualt():
	_number_input = 1
	_bet_amount = 1







func _on_left_pressed():
	if(_number_input - 1 < 1 ):
		return
	_number_input -= 1


func _on_right_pressed():
	if(_number_input + 1 > 6 ):
		return
	_number_input += 1

func _on_plus_one_pressed():
	if(_bet_amount + 1 > maxBet):
		return
	_bet_amount += minBet
	

func _on_plus_ten_pressed():
	if(_bet_amount + 10 > maxBet):
		return
	_bet_amount += 10


func _on_minus_one_pressed():
	if(_bet_amount - 1 < minBet):
		return
	_bet_amount -= minBet


func _on_minus_ten_pressed():
	if(_bet_amount - 10 < minBet):
		return
	_bet_amount -= 10

func _on_entire_pressed():
	_bet_amount = character.player_money


func _on_sure_btn_pressed():
	if(game):
		game.get_player_input(_number_input, _bet_amount)
		return
	printerr("'game' can't be null")




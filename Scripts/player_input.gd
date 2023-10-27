extends MarginContainer

class_name PlayerInput

@onready var left_btn := %left
@onready var right_btn := %right
@onready var sight_t := %sight_t
@onready var amount := %amount

var maxBet : int = 150
var minBet : int = 1

var game: Game
var character: Character

var _number_input: int = 1:
	set(newValue):
		_number_input = newValue 
		match _number_input:
			1:
				sight_t.texture = game.texture1
			2:
				sight_t.texture = game.texture2
			3:
				sight_t.texture = game.texture3
			4:
				sight_t.texture = game.texture4
			5:
				sight_t.texture = game.texture5
			6:
				sight_t.texture = game.texture6

var _bet_amount: int = 10:
	set(newValue):
		_bet_amount = newValue
		amount.text = str(_bet_amount)




func _ready():
	amount.text = str(_bet_amount)
	

func _process(delta):
	if( !character ):
		printerr("something wrong with character")


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
	_bet_amount = maxBet


func _on_sure_btn_pressed():
	if(game):
		game.get_player_input(_number_input, _bet_amount)
		return
	printerr("'game' can't be null")



func _on_min_pressed():
	_bet_amount = minBet

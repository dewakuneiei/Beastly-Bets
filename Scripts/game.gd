extends Node2D

class_name Game

@export var ui : UI
@export var gameover_ui : GameOverUI
@export var character: Character

@onready var soundEffect : AudioStreamPlayer2D = %soundEffect

var rng = RandomNumberGenerator.new()
var outcome:int

var allResult: Array

var texture1 : Texture2D
var texture2 : Texture2D
var texture3 : Texture2D
var texture4 : Texture2D
var texture5 : Texture2D
var texture6 : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_setupImage()
	
	if( !ui ):
		printerr("UI is missing!")

	if( !character ):
		printerr("Game's character is missing!")
	
	if( !gameover_ui):
		printerr("Game over ui do not reffer.")
	
	ui.showStart(true)
	gameover_ui.setVisible(false)
	ui.show_money_bet(false)
	gameReset()
	

func _setupImage() :
	texture1 = preload("res://Assets/dices/dice_1.png")
	texture2 = preload("res://Assets/dices/dice_2.png")
	texture3 = preload("res://Assets/dices/dice_3.png")
	texture4 = preload("res://Assets/dices/dice_4.png")
	texture5 = preload("res://Assets/dices/dice_5.png")
	texture6 = preload("res://Assets/dices/dice_6.png")

func _on_ui_start_the_game():
	# Player Input show on display
	ui.showInputScene(true)



func get_player_input(guess_number: int, bet_amount: int):
	
	#Player set
	character.p_guess = guess_number
	character.p_bet = bet_amount
	character.player_money -= bet_amount
	
	#COM Set
	character.m_bet = bet_amount
	character.monster_money -= bet_amount
	com_guessed()
	
	# UI SET
	ui.set_monster_bet_text(character.m_bet)
	ui.set_player_bet_text(character.p_bet)
	ui.showInputScene(false)
	ui.show_money_bet(true)
	ui.playMoneySlideAnim()
	
	
	ui.set_number(character.m_guess, character.p_guess)
	rolledDice()



func com_guessed():
	character.m_guess = rng.randi_range(1, 6)
	while(character.m_guess == character.p_guess):
		character.m_guess = rng.randi_range(1, 6)

#fix here ----------------------------------*
func rolledDice():
	soundEffect.play()
	outcome = rng.randi_range(1, 6)
	print("outcome: ", outcome)
	ui.rollDice()
	

func _on_game_ui_finished_rolling():
	allResult.append(findWinner())
	ui.set_image(outcome)
	ui.outcomeStarted()

func findWinner() -> Dictionary:
	# p = player, m = monster, n = none
	if( character.p_guess == outcome):
		var r = {"winner" : 'p', "dist" : 0}
		return r
	elif (character.m_guess == outcome):
		var r = {"winner" : 'm', "dist" : 0}
		return r
	else :
		var p_dist = abs(character.p_guess - outcome)
		var m_dist = abs(character.m_guess - outcome)
		
		if(p_dist < m_dist):
			var r = {"winner" : 'p', "dist" : p_dist}
			return r
		elif (p_dist == m_dist):
			var r = {"winner" : 'n', "dist" : p_dist}
			return r
		else:
			var r = {"winner" : 'm', "dist" : m_dist}
			return r

# who is receive money
func _on_ui_outcome_timeout():
	var result : Dictionary = allResult[allResult.size() - 1]
	var winner = result["winner"]
	var dist = result["dist"]
	
	var p_bet = character.p_bet
	var m_bet = character.m_bet
	
	if	(
		dist == 0 and
		winner == 'p'
		):
		var total = sum(p_bet, p_bet)
		character.player_get_money(total)
		character.monster_get_money(m_bet - p_bet)

		
	elif	(
		dist == 0 and
		winner == 'm'
		):
		var total = sum(m_bet, m_bet)
		character.monster_get_money(total)
		character.player_get_money(p_bet - m_bet)

	elif	(
		dist != 0 and
		winner == 'p'
		):
		var half = int(p_bet) * .5
		var total = sum(p_bet, half)
		character.player_get_money(total)
		character.monster_get_money(m_bet - half)

	elif	(
		dist != 0 and
		winner == 'm'
		):
		var half = int(m_bet) * .5
		var total = sum(m_bet, half)
		character.monster_get_money(total)
		character.player_get_money(p_bet - half)

	else :
		character.player_get_money(p_bet)
		character.monster_get_money(m_bet)
	
	nextState()

# ------------  Current here ---------------
func nextState():
	var haveWinner = character.someIsZero()
	if( haveWinner != 'n'):
		gameEnded(haveWinner)
		return
	
	playGame()

func gameEnded(winner: String):
	gameover_ui.setVisible(true)
	
	if(winner == 'p'):
		gameover_ui.setTitleLabel("Monster Win!")
		
	else :
		gameover_ui.setTitleLabel("Player Win!")
	gameover_ui.setAllResult(allResult)

func playGame() :
	ui.showStart(true)
	gameReset()

func gameReset():
	ui.set_monster_bet_text(0)
	ui.set_player_bet_text(0)
	character.m_bet = 0
	character.p_bet = 0
	ui.show_money_bet(false)

func sum(a: int, b:int):
	return a + b


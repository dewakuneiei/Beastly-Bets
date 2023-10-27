extends CanvasLayer

class_name UI
@onready var m_money := %m_money
@onready var p_money := %p_money

@onready var mon_g_t := %mon_g_t
@onready var player_g_t := %player_g_t

@onready var start_btn := %start_btn
@onready var outcome_l := %outcome_l

@onready var timerOutcome := $ShowOutcome
@onready var timerNotifly := $Notifly
@onready var timerRolling := $DiceRolling

@onready var _m_bet_l = %m_bet_l
@onready var _p_bet_l = %p_bet_l
@onready var _outcome_t = %outcome_t

@onready var player_input : PlayerInput = %InputNode

@export var game : Game
@export var character: Character

@onready var _anim_player : AnimationPlayer = %animPlayer

@export var negativeColor: Color
@export var positiveColor: Color


var last_result : Dictionary

# used for count the outcome round timeout
var index_time

#for rolling animated
const indexAnimated : int = 16
var counter : int = 1

signal startTheGame
signal outcomeTimeout
signal finishedRolling

func  _process(delta):
	m_money.text = str(character.monster_money)
	p_money.text = str(character.player_money)

func _ready():
	if(!character):
		printerr("do not refer character")
	player_input.character = character
	if(!game):
		printerr("do not refer game")
	player_input.game = game
	
	outcome_l.visible = false
	_outcome_t.visible = false
	showInputScene(false)

	
	# do not change this value
	index_time = 0
	

func showHeadCenter(isVisible: bool):
	mon_g_t.get_parent().visible = isVisible

func showStart(isVisible: bool) -> void:
	start_btn.visible = isVisible
	showHeadCenter(!start_btn.visible)

func showInputScene(isVisible: bool) -> void:
	if( isVisible ):
		player_input.visible = true
		start_btn.visible = false
		showHeadCenter(false)
		return
	player_input.visible = false
	showStart(false)

func _on_start_btn_pressed():
	startTheGame.emit()

func set_number(num1: int, num2: int):
		mon_g_t.texture = GetTexture(num1)
		player_g_t.texture = GetTexture(num2)
		

func GetTexture(value: int):
		match value:
			1:
				return game.texture1
			2:
				return game.texture2
			3:
				return game.texture3
			4:
				return game.texture4
			5:
				return game.texture5
			6:
				return game.texture6

func outcomeStarted():
	timerOutcome.start()


func _on_show_outcome_timeout():
	_outcome_t.visible = false
	outcome_l.visible = true
	
	last_result = game.allResult[game.allResult.size() - 1]
	
	if(last_result["winner"] == 'n'):
		outcome_l.text = "DRAW!"
	elif (
		last_result["dist"] == 0 and 
		last_result["winner"] == 'p'):
			outcome_l.text = "CORRECT!"
	elif (
		last_result["dist"] == 0 and 
		last_result["winner"] == 'm'):
			outcome_l.text = "Monster is correct!"
	elif (
		last_result["dist"] != 0 and 
		last_result["winner"] == 'm'):
			outcome_l.text = "Monster takes 50%"
	elif (
		last_result["dist"] != 0 and 
		last_result["winner"] == 'p'):
			outcome_l.text = "You take 50%."	
	
	timerNotifly.start()
	


func _on_notifly_timeout():
	outcome_l.visible = false
	outcomeTimeout.emit()
	
func set_monster_bet_text(text):
	_m_bet_l.text = str(text)

func set_player_bet_text(text):
	_p_bet_l.text = str(text)

func show_money_bet(isVisible: bool):
	_m_bet_l.get_parent().visible = isVisible
	_p_bet_l.get_parent().visible = isVisible
	

func set_image(num: int):
	num = ((num - 1) % 6) + 1
	match num:
		1:
			_outcome_t.texture = game.texture1
		2:
			_outcome_t.texture = game.texture2
		3:
			_outcome_t.texture = game.texture3
		4:
			_outcome_t.texture = game.texture4
		5:
			_outcome_t.texture = game.texture5
		6:
			_outcome_t.texture = game.texture6

# fix here !!!!!!!!!!!!!!!!!
func playMoneySlideAnim():
	_anim_player.play("slide")
	

func rollDice():
	_outcome_t.visible = true
	timerRolling.start()
	counter = 0

# for rolling animated
func _on_dice_rolling_timeout():
	if(counter > indexAnimated):
		finishedRolling.emit()
		timerRolling.stop()
		_anim_player.play("outcome")
		return
	
	set_image(counter)
	counter += 1
	timerRolling.start()


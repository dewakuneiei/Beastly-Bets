extends CanvasLayer

class_name UI
@onready var m_money := %m_money
@onready var p_money := %p_money
@onready var g_number := %g_number
@onready var start_btn := %start_btn
@onready var outcome_l := %outcome_l
@onready var timerOutcome := $ShowOutcome
@onready var timerNotifly := $Notifly
@onready var _m_bet_l = %m_bet_l
@onready var _p_bet_l = %p_bet_l
@onready var _outcome_t = %outcome_t

@onready var player_input : PlayerInput = %InputNode


@export var game : Game
@export var character: Character

@onready var _anim_player1 : AnimationPlayer = %AnimationPlayer1
@onready var _anim_player2 : AnimationPlayer = %AnimationPlayer2

# used for count the outcome round timeout
var index_time

var texture1 : Texture2D
var texture2 : Texture2D
var texture3 : Texture2D
var texture4 : Texture2D
var texture5 : Texture2D
var texture6 : Texture2D

signal startTheGame
signal outcomeTimeout

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
	
	_setupImage()
	
	# do not change this value
	index_time = 0

func _setupImage() :
	texture1 = preload("res://Assets/dices/dice_1.png")
	texture2 = preload("res://Assets/dices/dice_2.png")
	texture3 = preload("res://Assets/dices/dice_3.png")
	texture4 = preload("res://Assets/dices/dice_4.png")
	texture5 = preload("res://Assets/dices/dice_5.png")
	texture6 = preload("res://Assets/dices/dice_6.png")
	
	
func showStart(isVisible: bool) -> void:
	start_btn.visible = isVisible
	g_number.visible = !start_btn.visible

func showInputScene(isVisible: bool) -> void:
	if( isVisible ):
		player_input.visible = true
		start_btn.visible = false
		g_number.visible = false
		return
	player_input.visible = false
	showStart(false)

func _on_start_btn_pressed():
	startTheGame.emit()

func set_number(text: String):
	g_number.text = text

func showOutcome(arr):
	_outcome_t.visible = true
	timerOutcome.start()


func _on_show_outcome_timeout():
	_outcome_t.visible = false
	outcome_l.visible = true
	
	var last_result : Dictionary = game.allResult[game.allResult.size() - 1]
	
	if(last_result["winner"] == 'n'):
		outcome_l.text = "DRAW!"
	elif (
		last_result["dist"] == 0 and 
		last_result["winner"] == 'p'):
			outcome_l.text = "PLAYER CORRECT!"
	elif (
		last_result["dist"] == 0 and 
		last_result["winner"] == 'm'):
			outcome_l.text = "MONSTER CORRECT!"
	elif (
		last_result["dist"] != 0 and 
		last_result["winner"] == 'm'):
			outcome_l.text = "MONSTER IS CLOSEST"
	elif (
		last_result["dist"] != 0 and 
		last_result["winner"] == 'p'):
			outcome_l.text = "PLAYER IS CLOSEST"	
	
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
	match num:
		1:
			_outcome_t.texture = texture1
		2:
			_outcome_t.texture = texture2
		3:
			_outcome_t.texture = texture3
		4:
			_outcome_t.texture = texture4
		5:
			_outcome_t.texture = texture5
		6:
			_outcome_t.texture = texture6

func playMoneySlideAnim():
	_anim_player1.play("slide")
	_anim_player2.play("slide")

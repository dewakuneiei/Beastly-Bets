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


@onready var player_input : PlayerInput = %InputNode

@export var game : Game
@export var character: Character

# used for count the outcome round timeout
var index_time

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
	showInputScene(false)
	
	# do not change this value
	index_time = 0
	
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
	outcome_l.text = str(arr)
	outcome_l.visible = true
	timerOutcome.start()


func _on_show_outcome_timeout():
	# bug
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

func show_bet_label(isVisible: bool):
	_m_bet_l.visible = isVisible
	_p_bet_l.visible = isVisible

extends CanvasLayer

class_name UI
@onready var m_money := %m_money
@onready var p_money := %p_money
@onready var g_number := %g_number
@onready var start_btn := %start_btn

@onready var player_input : PlayerInput = %InputNode

@export var game : Game
@export var character: Character

signal startTheGame

func  _process(delta):
	m_money.text = str(character.monster_money)
	p_money.text = str(character.player_money)

func _ready():
	if(character):
		player_input.character = character
	if(game):
		player_input.game = game
	
	showInputScene(false)
	
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

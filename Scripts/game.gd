extends Node2D

class_name Game

@export var ui : UI

# Called when the node enters the scene tree for the first time.
func _ready():
	if( ui ):
		ui.showStart(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ui_start_the_game():
	ui.showInputScene(true)

# ------------  Current here ---------------
func get_player_input(guess_number: int, bet_amount: int):
	print("Player guessed: ",guess_number)
	print("Player bet: ", bet_amount)
	ui.showInputScene(false)
	ui.set_number("1:{p}".format({"p":str(guess_number)}))

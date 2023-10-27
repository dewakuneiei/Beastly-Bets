extends CanvasLayer
class_name GameOverUI

@onready var _title_l = %GameOverTitle
@onready var _allResult_l = %allResult_l
@onready var _again_btn = %againBtn

func setVisible(isVisible: bool) -> void:
	self.visible = isVisible

func setTitleLabel(first) -> void:
	_title_l.text = str(first)

func setAllResult( arr: Array) -> void:
	var text = ""
	var pwin = 0
	var mwin = 0
	var cpwin = 0
	var cmwin = 0
	var draw = 0
	var rounds = 0
	
	for object in arr:
		rounds += 1
		text += str(rounds) + ". "
		if(
			object["dist"] == 0 and 
			object["winner"] == 'p'):
				text += "You correctly!"
				pwin +=1
		elif(
			object["dist"] == 0 and 
			object["winner"] == 'm'):
				text += "Monster correctly!"
				mwin += 1
		elif(
			object["dist"] != 0 and 
			object["winner"] == 'p'):
				text += "(P)Closely"
				cpwin += 1
		elif(
			object["dist"] != 0 and 
			object["winner"] == 'm'):
				text += "(M)Closely"
				cmwin += 1
		else:
			text += "DRAW"
			draw += 1
		text += "\n"
	text = "Player correct: {pwn}\nMonster correct: {mwn}\n(P)CLOSELY: {cp}\n(M)CLOSELY: {cm}\nDRAW: {dw}\nRounds: {rds}\n\nNote\n{note}".format(
		{"pwn": pwin, "mwn": mwin, "cp": cpwin, "cm":cmwin,"dw":draw, "rds": rounds, "note": text}
	)
	_allResult_l.text = text


func _on_again_btn_pressed():
	get_tree().reload_current_scene()

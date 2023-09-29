extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var score = $Saver.read_savegame()
	if score == 0:
		$Score.set_text("")
	else:
		$Score.set_text("Highest Score: "+str(score))

func _on_Start_pressed():
	get_tree().change_scene("res://Main.tscn")

func _on_Tutorial_pressed():
	get_tree().change_scene("res://Tutorial.tscn")

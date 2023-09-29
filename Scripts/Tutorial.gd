extends Node

var id = 0
var ran = false
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func TutText(Text):
	var obj = $"../TutorialText"
	if !ran:
		$AnimationPlayer.play("Run")
		obj.set_text(Text)
		ran = true
	else:
		if Input.is_action_just_pressed("ui_accept"):
			if $AnimationPlayer.is_playing():
				$AnimationPlayer.play("Stop")
			else:
				id += 1
				ran = false
				$AnimationPlayer.play("Run")
func Clean():
	$"../TutorialText".set_text("")
func _process(delta):
	match id:
		0: TutText("Hello")
		1: TutText("I will be your coach for today")
		2: TutText("Also don't worry about the blood splatter on the cardboard cutout")
		3: TutText("It's just fake blood")
		4: TutText("It'll help us with our training")
		5: TutText("Let me clean that blood off")
		6:
			$"../Stand/Blood".set_visible(false)
			TutText("Anyway...")
		7: TutText("Let's start with the clean ones")
		8: TutText("Rule 1: The clean ones are innocent")
		9: TutText("So leave them be, don't slam your gavel in their precense...")
		10: TutText("Don't touch anything and yada yada yada you get the point")
		11: TutText("Here's a thing to help you if you're doing good or not")
		12:
			TutText("Consider it as a temporary gift from me")
			$"../JudgeTable/Feel".set_visible(true)
		13:
			if ran == false:
				Clean()
				$"../Audio/Intro".play()
				$"..".custom_pattern = [0,0,0,0,0,0,0,0]
				ran = true
		14: 
			ran = false
			id += 1
		15: TutText("Good Job")
		16: TutText("Rule 2: The messy ones are guilty")
		17: TutText("Press the spacebar to declare them guilty")
		18: TutText("But do it in the beat")
		19: TutText("If you don't know what I mean...")
		20: TutText("I'll just give you another temporary gift")
		21: 
			TutText("Here you go")
			$"../JudgeTable/Beat Detector".set_visible(true)
			$"../JudgeTable/Beat Detector/Switch2D".Integer_Change(1)
		22:
			TutText("Keep your eyes on the marker and slam the gavel on time")
		23:
			if ran == false:
				Clean()
				$"../Audio/Intro".play()
				$"..".custom_pattern = [1,1,1,1,1,1,1,1]
				ran = true
		24: 
			ran = false
			id += 1
		25: TutText("Nice")
		26: TutText("Rule 3: If lawyers are present their client is guilty")
		27: TutText("Slam the gavel and they will object")
		28: TutText("Slam the gavel again to prove them wrong")
		29: TutText("You have a ton of evidence from these related cases")
		30: TutText("And refer to my gift if you're confused")
		31:
			if ran == false:
				Clean()
				$"../Animators/EvidAnim".play("Putin")
				$"../JudgeTable/Beat Detector/Switch2D".Integer_Change(2)
				$"../Audio/Intro".play()
				$"..".custom_pattern = [2,2,2,2,2,2,2,2]
				ran = true
		32: 
			$"../Animators/EvidAnim".play("Putout")
			ran = false
			id += 1
		33: TutText("Now you're ready play this game")
		34: TutText("Good Luck!")
		35: get_tree().change_scene("res://Menu.tscn")

extends Control

var EventScript = [false,false,false,false,false,false,false,false]
var CatchyEventScripts
var BPM = 130
var LatestTime = 0 setget _CheckLatestTime
var LatestPosition = -1
var LatestEvent = 0
export(bool) var tutorial_mode = false
export(bool) var count_exists = true
export(Array) var custom_pattern = [0,0,0,0,0,0,0,0]
export(bool) var enable_custom_pattern = false
var pool_check = [false,false]
var count = -1
var isgameover = false
var mercy_distant = 8.0
var mercy_press = 8.0
var restart = false
var isProcessing = false

func gameover():
	print("YOU LOSE")
	if !tutorial_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		isProcessing = false
		isgameover = true
		if $Audio/Slice1.get_volume_db() == -80: $Audio/Slice1.stop()
		if $Audio/Slice2.get_volume_db() == -80: $Audio/Slice2.stop() 
		$Animators/OverAnim.play("GameOver")
		$Over/Score.set_text(str(count))
		$Saver.save(count)
	else:
		restart = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if count_exists: $JudgeTable/Count/Label.set_text("0")
	var data_file = File.new()
	data_file.open("res://EventScriptList.json",File.READ)
	var data_text = data_file.get_as_text()
	data_file.close()
	CatchyEventScripts = JSON.parse(data_text).result
	if tutorial_mode: 
		isgameover = true
	else:
		RandomEventScript()
	set_process_input(true)

func getSPB():
	return 60/float(BPM)

func RandomEventScript():
	if enable_custom_pattern:
		EventScript = Array(custom_pattern)
	else:
		randomize()
		EventScript = CatchyEventScripts[randi() % CatchyEventScripts.size()]
	print(EventScript)
	if tutorial_mode: tutorial_nextphase()

func _process(delta):
	if isProcessing:
		_CheckLatestTime($Audio/Slice2.get_playback_position())
		var Slice = $Audio/Slice2.get_playback_position()/getSPB()/2
		var Slice2Bool = int(Slice)
		if tutorial_mode:
			$"JudgeTable/Beat Detector/Marker".set_position(Vector2(lerp(-122,118,fmod($Audio/Slice2.get_playback_position()/getSPB()/2,1.0)),0))
			$"JudgeTable/Feel".Integer_Change(int(!restart)+1)
		_CheckLatestEvent(Slice2Bool,EventScript[Slice2Bool],Slice)
		if EventScript[Slice2Bool] == 0 and fmod($Audio/Slice2.get_playback_position()/getSPB()/2,1.0) > 0.5:
			$Verdict.Integer_Change(1)
		$Audio/Slice2.set_volume_db(-80*int(EventScript[Slice2Bool] == 0 or EventScript[Slice2Bool] == 2))

func tutorial_nextphase():
	if !restart:
		restart = true
	else:
		isProcessing = false
		isgameover = true
		$Audio/Slice1.stop()
		$Audio/Slice2.stop()
		$Tutorial.id += 1

func _CheckLatestEvent(pos,ev,sl):
	var LP1 = LatestPosition
	var LP2 = pos
	var LE1 = LatestEvent
	var LE2 = ev
	pool_check_fail(LE2,sl)
	if LP1 != LP2:
		pool_check = [false,false]
		RandomSuspect()
		$Verdict.Integer_Change(0)
		if LE2 == 2 and LE1 != 2:
			$Animators/EvidAnim.play("Putin")
		if LE2 != 2 and LE1 == 2:
			$Animators/EvidAnim.play("Putout")
		if LE2 == 2 and LE1 == 2:
			$Animators/LawAnim.play("Idle")
		
		if LE2 == 0 or LE2 == 2: $Animators/SlimeAnim.play("Off")
		if LE2 == 1: $Animators/SlimeAnim.play("On")
	
	LatestPosition = pos
	LatestEvent = ev

func RandomSuspect():
	count += 1
	if count_exists: $JudgeTable/Count/Label.set_text(str(count))
	if !tutorial_mode: 
		var randSus = (randi()%3)+1
		$Stand/Suspects.Integer_Change(randSus)
		$Stand/Suspects/Blood.Integer_Change(randSus)
		$Animators/BeatAnim.play("Bum")

func _CheckLatestTime(val):
	if val < LatestTime:
		RandomEventScript()
		var Slice2Bool = int($Audio/Slice2.get_playback_position()/getSPB()/2)
	LatestTime = val

func beat_check(mercy):
	var cur = $Audio/Slice2.get_playback_position()/getSPB()/2
	var barson2 = fmod(cur,1.0)
	var Marker = EventScript[int(cur)]
	if Marker == 0:
		gameover()
	if Marker == 1:
		if barson2 >= 0.5-1.0/mercy and barson2 <= 0.5+1.0/mercy:
			print("you pass")
			if pool_check[0] == true:
				gameover()
			pool_check[0] = true
			$Verdict.Integer_Change(2)
		else:
			gameover()
	if Marker == 2:
		if barson2 >= 0.5-1.0/mercy and barson2 <= 0.5+1.0/mercy:
			$Animators/LawAnim.play("Objection")
			$Verdict.Integer_Change(3)
			$Verdict/lawyer/State1.set_visible(true)
			$Verdict/lawyer/State2.set_visible(false)
			print("you pass")
			if pool_check[0] == true:
				gameover()
			pool_check[0] = true
		elif barson2 >= 0.75-1.0/mercy and barson2 <= 0.75+1.0/mercy:
			$Animators/LawAnim.play("Fail")
			$Verdict/lawyer/State2.set_visible(true)
			print("you pass")
			if pool_check[1] == true:
				gameover()
			pool_check[1] = true
		else:
			gameover()

func pool_check_fail(event,slice):
	var des = fmod(slice,1.0)
	if event == 1:
		if des > 0.5+1.0/mercy_distant and pool_check[0] == false:
			gameover()
	if event == 2:
		if des > 0.5+1.0/mercy_distant and pool_check[0] == false:
			gameover()
		if des > 0.75+1.0/mercy_distant and pool_check[1] == false:
			gameover()

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if !isgameover: 
			$Audio/Gavel.play()
			$Animators/GavelAnim.play("gavel_hit")
		if isProcessing: beat_check(mercy_press)
	if Input.is_action_just_released("ui_accept"):
		$Animators/GavelAnim.play("gavel_idle")

func _on_Intro_finished():
	isProcessing = true
	isgameover = false
	restart = true
	if !tutorial_mode: 
		$Stand/Suspects.set_visible(true)
	else:
		EventScript = Array(custom_pattern)
	$Audio/Slice1.play()
	$Audio/Slice2.play()

func _on_PlayAgain_Button_pressed():
	print("restart")
	if isgameover: get_tree().reload_current_scene()

func _on_MainMenu_Button_pressed():
	if isgameover: get_tree().change_scene("res://Menu.tscn")

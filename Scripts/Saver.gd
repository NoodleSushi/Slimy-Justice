extends Node

var savegame = File.new()
var save_path = "user://Slimy Justice.save" #place of the file
var save_data = {"topscore": 0} #variable to store data

func create_save():
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func save(high_score):
	save_data["topscore"] = high_score #data to save
	savegame.open(save_path, File.WRITE) #open file to write
	savegame.store_var(save_data) #store the data
	savegame.close() # close the file

func read_savegame():
	savegame.open(save_path, File.READ) #open the file
	save_data = savegame.get_var() #get the value
	savegame.close() #close the file
	return save_data["topscore"] #return the value

var topscore = 0

func _ready():
	if not savegame.file_exists(save_path):
		create_save()
	topscore = read_savegame()

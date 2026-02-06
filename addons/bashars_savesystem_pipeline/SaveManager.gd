extends Node

## A Class that handles the backend save pipeline of any arbitrary game 

## Constant Information
var SAVE_PATH = "user://Saves"
const SLOT_PREFIX = "Slot_"
const SETTINGS_FILENAME = "SETTINGS.tres"
const MAIN_GAME_SAVE_FILENAME = "MAIN_SAVE.tres"

## Save Slot Information
var number_of_slots : int = 3  # The nuumber of save slots to create 
var current_save_slot : int = 1 #The current selected saveslot being played 


## Save Resource Information 
var main_game_save : Game_Save # The main game save file (Stored in a save file) 
var settings_save : Settings_Save # The settings save file (Stored outside of save files) 


## Other Information 
var no_save_mode : bool = false #If the game should be played in a "No-Save" mode 
var time_start := 0 # The start time when the game is loaded (used for playtime information) 



@export var use_version_in_savepath : bool = false

func _ready() -> void:
	
	if(use_version_in_savepath): 
		## Change Save Path depending on version number! 
		SAVE_PATH = str(SAVE_PATH, "/", ProjectSettings.get_setting("application/config/version"))
	
	#Ensure SAVE is ALWAYS running 
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	#Get the start time of the session 
	time_start = Time.get_unix_time_from_system()
	
	#On Game load, check if Save structure exists and setup 
	#We ignore Save data if we are on web automaticly 
	if(OS.get_name() == "Web"):
		#Enter "No-Save" mode that will not save the game
		no_save_mode = true
	else:
		no_save_mode = false
		check_for_save_structure()
	
	#Always create a local copy of the settings and the main game save file!
	#setup_save_objects()
	load_settings_save()
	load_main_game_save()


func _notification(what: int) -> void:
	if(what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_CRASH or what == NOTIFICATION_EXIT_TREE):
		#Save as much as we can!
		write_main_game_save()
		write_settings()


##Sets up objects to be used for the save system 
#func setup_save_objects():
	#
	##Create new objects with default values
	#main_game_save = Game_Save.new()
	#settings_save = Settings_Save.new()

#Checks for correct save-structure and corrects if it does not exist 
func check_for_save_structure():
	
	#ONLY DO IF WE ARE ALLOWED TO SAVE
	if(!no_save_mode):
		
		var dir = DirAccess.open(SAVE_PATH)
		if(dir == null):
			print(str("First-Time-Setup: Creating Savepath at ", SAVE_PATH))
			DirAccess.make_dir_recursive_absolute(SAVE_PATH)
		else:
			print(str(SAVE_PATH, " Exists!"))
		
		#Create 3 Save Folders if they do not exist 
		for i in range(1, number_of_slots + 1):
			create_new_save_file(i)
		
		#Create blank Settings data that exists outside of save filees
		load_settings_save()







## Save File Functions


#Creates a new empty save file in saveslot 
#Save Files are Folders that create Save Objects for specifc levelpacks 
func create_new_save_file(slot : int):
	#ONLY DO IF WE ARE ALLOWED TO SAVE
	if(!no_save_mode):
		
		var path = str(SAVE_PATH, "/", SLOT_PREFIX, slot)
		var dir = DirAccess.open(path)
		if(dir == null):
			print(str("First-Time-Setup: Creating SaveFile Slot at ", path))
			DirAccess.make_dir_recursive_absolute(path)
			
			#Create blank Main Game Save data that exists inside of the save slot
			
		else:
			print(str(path, " Exists!"))


#Deletes a save file in a save slot by making a file in that slot 
func delete_save_file_in_slot(slot : int):
	
	#ONLY DO IF WE ARE ALLOWED TO SAVE
	if(!no_save_mode):
		
		var path = str(SAVE_PATH, "/", SLOT_PREFIX, slot)
		var dir = DirAccess.open(path)
		if(dir == null):
			print(str("First-Time-Setup: Creating SaveFile Slot at ", path))
			DirAccess.make_dir_recursive_absolute(path)
		else:
			
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				var file_path = str(path,"/", file_name)
				dir.remove_absolute(file_path)
				file_name = dir.get_next()
			dir.list_dir_end()
			
			dir.remove(path)
	
	create_new_save_file(slot)



## Settings Save Functions

func load_settings_save():
	
	#ONLY DO IF WE ARE ALLOWED TO SAVE
	if(!no_save_mode):
		
		var path = str(SAVE_PATH, "/", SETTINGS_FILENAME)
		#Attempt to load settings save
		settings_save = ResourceLoader.load(path)
		if(settings_save != null):
			print(str("Saved Settings Loaded!"))
		else:
			#If settings was unable to be loaded, create a new one!
			settings_save = Settings_Save.new()
			write_settings()
		
		## Settings file contains selected slot information! 
		current_save_slot = settings_save.current_selected_save_slot
	else:
		## Always make a settings save in no save mode!
		settings_save = Settings_Save.new()

func write_settings():
	#ONLY DO IF WE ARE ALLOWED TO SAVE
	if(!no_save_mode):
		settings_save.current_selected_save_slot = current_save_slot
		
		var path = str(SAVE_PATH, "/", SETTINGS_FILENAME)
		var save = ResourceSaver.save(settings_save, path)
		if(save == OK):
			print("Settings sucessfuly saved!")
		else: 
			print("ERROR: Game Settings were not saved!")





## Game-Specifc Save Instructions 
## Everything below here is game-specifc implementation! 




## Main Game Save Read/Write 

#Loads a main game save file 
func load_main_game_save():
	
	#ONLY DO IF WE ARE ALLOWED TO SAVE
	if(!no_save_mode):
		
		var path = str(SAVE_PATH, "/", SLOT_PREFIX, current_save_slot, "/", MAIN_GAME_SAVE_FILENAME)
		#Attempt to load selected pack path
		main_game_save =  ResourceLoader.load(path)
		if(main_game_save != null):
			print(str("Main game save loaded for slot: ", current_save_slot))
		else:
			#If the levelpack save was unable to be loaded, create a new one
			main_game_save = Game_Save.new()
			#current_pack_save.level_pack = pack
			#current_pack_save.level_saves.resize(99) #Set level array to 99 levels (Max)
			#current_pack_save.all_levels_finished = false
			#current_pack_save.all_oranges_collected = false
			#Write to slot
			write_main_game_save()
	else:
		## No save mode should have a main game save local only! 
		main_game_save = Game_Save.new()
	
	
	if(OS.has_feature("Beta")):
		main_game_save.unlocked_oranges = true


## Fetch a game save from the filesystem 
func fetch_main_game_save(slot : int) -> Game_Save:
	#ONLY DO IF WE ARE ALLOWED TO SAVE
	if(!no_save_mode):
		var path = str(SAVE_PATH, "/", SLOT_PREFIX, slot, "/", MAIN_GAME_SAVE_FILENAME)
		#Attempt to load selected pack path
		var main_save =  ResourceLoader.load(path)
		return main_save
	else:
		return null

#Saves main game save to current slot 
func write_main_game_save(): 
	
	#When saving, always update time spent in the save file!
	var current_time = Time.get_unix_time_from_system()
	var time_passed = current_time - time_start
	main_game_save.playtime = main_game_save.playtime + time_passed
	time_start = current_time #Set for next time interval! 
	
	#ONLY DO IF WE ARE ALLOWED TO SAVE
	if(!no_save_mode):
		
		var path = str(SAVE_PATH, "/", SLOT_PREFIX, current_save_slot, "/", MAIN_GAME_SAVE_FILENAME)
		var save = ResourceSaver.save(main_game_save, path)
		if(save == OK):
			print(str("Saving progress for Main Save in slot: ", current_save_slot))
		else:
			pass

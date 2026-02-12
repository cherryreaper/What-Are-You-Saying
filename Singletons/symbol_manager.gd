extends Node


## Class to handle reading Symbol data & Language & Puzzle Spawning

enum Parts_Of_Speach {MODIFIER, PRIMARY, DESCRIPTIVE} ## In order! (Very important for readable code!) 

const SYMBOL_JSON_PATH = "res://Data/WAYS Symbols.json" ## Path to the JSON file for Symbol data
const PUZZLE_JSON_PATH = "res://Data/Puzzles.json" ##Path to the JSON file for puzzle data

var symbol_refrence = preload("res://Scenes/Abstracts/Abstract_Symbol.tscn")
var _symbol_data : Dictionary ## Refrence to loaded symbol data as a Dict

var _puzzle_data : Dictionary

func _ready() -> void:
	## Populate data from json
	if(not _symbol_data):
		var json_as_text = FileAccess.get_file_as_string(SYMBOL_JSON_PATH)
		_symbol_data = JSON.parse_string(json_as_text)
	
	if(not _puzzle_data):
		var json_as_text = FileAccess.get_file_as_string(PUZZLE_JSON_PATH)
		_puzzle_data = JSON.parse_string(json_as_text)

## Returns a symbol object from the dataset based on the word 
func create_symbol_object(word_id : String) -> Abstract_Symbol:
	
	var symbol : Abstract_Symbol = symbol_refrence.instantiate()
	## Populate data from Dict
	var data = _symbol_data.get(word_id.to_pascal_case())
	if(data is Dictionary):
		symbol.id = data.get("ID")
		symbol.image_path = data.get("SPRITE_PATH")
		symbol.correct_translation = word_id
	else:
		breakpoint
		print("Symbol Word_ID is invalid!")
	
	return symbol



## Returns a data object that represents how to display a phrase from a given puzzle ID
func get_puzzle_phrase_from_id(id : String) -> Array[Array]:
	
	var phrase_arr : Array[Array] = []
	var part_index : int = 0
	
	while  part_index != -1:
		var row = _puzzle_data.get(str(id, "_", part_index))
		if(row): ## If data was found for this ID + index
			
			var part_of_speach : int = 0
			var row_array : Array[Abstract_Symbol] = []
			for type in row:
				## Create symbol objects
				var symbol_as_string = row.get(type)
				var symbol
				if(symbol_as_string):
					symbol = create_symbol_object(row.get(type))
				else:
					## Make a blank space symbol
					symbol = create_symbol_object("Blank_Space")
				## Append it to the array!
				row_array.append(symbol)
				## Move counter!
				part_of_speach += 1
			
			## When finished append the smaller array!
			phrase_arr.append(row_array)
			
			part_index += 1
		else:
			## Break if we can not find any more lines! 
			part_index = -1
	
	return phrase_arr


## Spawns in symbols from a phrase inside a calling control object 
func spawn_symbols_in_control_from_phrase(phrase : Array[Array], control_object : Control):
	
	var part_of_speach : Parts_Of_Speach = 0
	
	for row in phrase:
		for symbol in row:
			control_object.add_child(symbol)

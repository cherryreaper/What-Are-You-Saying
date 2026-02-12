extends Node


## Class to handle reading Symbol data 

const SYMBOL_JSON_PATH = "res://Data/WAYS Symbols.json" ## Path to the JSON file for Symbol data
const PUZZLE_JSON_PATH = "res://Data/Puzzles.json" ##Path to the JSON file for puzzle data

var symbol_refrence = preload("res://Scenes/Abstracts/Abstract_Symbol.tscn")
var _symbol_data : Dictionary ## Refrence to loaded symbol data as a Dict

var _puzzle_data : Dictionary

func _ready() -> void:
	## Populate data from json
	if(not _symbol_data):
		var json_as_text = FileAccess.get_file_as_string(SYMBOL_JSON_PATH)
		_symbol_data = JSON.parse_string(json_as_text).values()[0]
	
	if(not _puzzle_data):
		var json_as_text = FileAccess.get_file_as_string(PUZZLE_JSON_PATH)
		_puzzle_data = JSON.parse_string(json_as_text)

## Returns a symbol object from the dataset based on the word 
func create_symbol_object(word_id : String) -> Abstract_Symbol:
	
	var symbol : Abstract_Symbol = symbol_refrence.instantiate()
	## Populate data from Dict
	var data : Dictionary = _symbol_data.get(word_id)
	if(data):
		symbol.id = data.get("ID")
		symbol.image_path = data.get("SPRITE_PATH")
		symbol.correct_translation = word_id
	else:
		breakpoint
		print("Symbol Word_ID is invalid!")
	
	return symbol




enum Phrase_Array_Index_Type {MODIFIER, PRIMARY, DESCRIPTIVE}

## Returns a data object that represents how to display a phrase from a given puzzle ID
func get_puzzle_phrase_from_id(id : String) -> Array[Array]:
	var phrase_arr : Array[Array] = []
	var part_index : int = 0
	
	
	
	
	
	
	return phrase_arr
	
	pass


## Spawns in symbols from a phrase inside a calling control object 
func spawn_symbols_in_control_from_phrase(phrase : Array[Array], control_object : Control):
	
	var type_index : Phrase_Array_Index_Type = 0
	
	for colum in phrase:
		for row in colum:
			pass
		pass
	
	pass

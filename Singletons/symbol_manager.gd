extends Node


## Class to handle reading Symbol data 

const SYMBOL_JSON_PATH = "res://Data/WAYS Symbols.json" ## Path to the JSON file for Symbol data

var symbol_refrence = preload("res://Scenes/Abstracts/Abstract_Symbol.tscn")
var _symbol_data : Dictionary ## Refrence to loaded symbol data as a Dict

func _ready() -> void:
	## Populate data from json
	if(not _symbol_data):
		var json_as_text = FileAccess.get_file_as_string(SYMBOL_JSON_PATH)
		_symbol_data = JSON.parse_string(json_as_text).values()[0]



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

class_name Abstract_Symbol
extends Control

var id : int = 0 ## The ID of this symbol 
var image_path : String = "res://Art/PLACEHOLDERS/Test_Smile.png"
var correct_translation : String = "CHANGE_THIS"




func _ready() -> void:
	$HoverSymbolInfo.visible = false
	
	## Load the correct image 
	if(FileAccess.file_exists(image_path)):
		$SymbolDisplay.texture = load(image_path)



## Ran when the player discovers this symbol for the first time
func first_time_display() -> Symbol_Save:
	##Otherwise the player has not encountered this symbol before!
	var symbol_save = Symbol_Save.new()
	symbol_save.player_guess = "???"
	SAVE.main_game_save.player_symbols[id] = symbol_save
	return symbol_save




## Mouse hover functions

func _on_mouse_entered() -> void:
	## Update shown info
	var symbol_save : Symbol_Save = SAVE.main_game_save.player_symbols[id]
	if(not symbol_save):
		symbol_save = first_time_display()
	$HoverSymbolInfo.symbol_translate.text = symbol_save.player_guess
	$HoverSymbolInfo.visible = true



func _on_mouse_exited() -> void:
	$HoverSymbolInfo.visible = false
	pass # Replace with function body.

extends Node2D


const test_word = "Active"
var test_word_id : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	
	for child in $GridContainer.get_children():
		child.queue_free()
	
	
	
	
	var phrase = SymbolManager.get_puzzle_phrase_from_id("leo_p2")
	SymbolManager.spawn_symbols_in_control_from_phrase(phrase, $GridContainer)
	
	
	
	#for i in range(1, 10):
		#$HBoxContainer.add_child(SymbolManager.create_symbol_object(test_word))
	#pass # Replace with function body.


func _on_line_edit_text_changed(new_text: String) -> void:
	
	SAVE.main_game_save.player_symbols[test_word_id].player_guess = new_text

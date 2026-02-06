class_name Abstract_Symbol
extends Control

var id : int = 0 ## The ID of this symbol 
var image_path : String = "res://Art/PLACEHOLDERS/Test_Smile.png"
var correct_translation : String = "CHANGE_THIS"




func _ready() -> void:
	
	## Load the correct image
	$SymbolDisplay.texture = load(image_path)
	
	
	
	

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	
	for i in range(1, 10):
		$HBoxContainer.add_child(SymbolManager.create_symbol_object("Smile"))
	pass # Replace with function body.

extends Resource
class_name Game_Save

#A class to keep track of Save status of the game at large 

@export var playtime : float = 0.0 #Stored in secconds 



@export var player_symbols : Array[Symbol_Save] = [] ## The symbols the player has encountered + their guess for them (The Index of the array = the symbol's ID!) 


func _init() -> void:
	if(player_symbols == []):
		player_symbols.resize(99)

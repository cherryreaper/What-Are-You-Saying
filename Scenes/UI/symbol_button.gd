extends Button


@onready var symbol : Abstract_Symbol = $AbstractSymbol

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	symbol.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	symbol._on_mouse_entered()


func _on_mouse_exited() -> void:
	symbol._on_mouse_exited()

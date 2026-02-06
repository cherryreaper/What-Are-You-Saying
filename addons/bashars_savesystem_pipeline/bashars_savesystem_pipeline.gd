@tool
extends EditorPlugin


func _enable_plugin() -> void:
	# The autoload can be a scene or script file.
	add_autoload_singleton("SAVE", "res://addons/bashars_savesystem_pipeline/SaveManager.gd")


func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton("SAVE")

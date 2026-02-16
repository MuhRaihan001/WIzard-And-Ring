extends Node2D
const MAIN_SCENE = preload("uid://b0biip11kcfm2")

func _ready() -> void:
	TextBox.textbox_end.connect(_on_dialog_end)
	
	var prolog_dialogs = [
		{"name": "Venuz", "text": "Tell me your wish....", "image": "res://cutscenes/prolog/grave.jpg"}
	]
	
	TextBox.start_dialog(prolog_dialogs, true)

func _on_dialog_end():
	get_tree().change_scene_to_packed(MAIN_SCENE)

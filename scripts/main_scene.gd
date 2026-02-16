extends Node2D
@onready var canvas_layer: CanvasLayer = $change_character/CanvasLayer
var can_open_menu: bool = true
var is_dialog_opened: bool = false
func _ready() -> void:
	canvas_layer.visible = false
	TextBox.textbox_start.connect(_is_dialog_started)
	TextBox.textbox_end.connect(_is_dialog_ended)

func _is_dialog_started():
	is_dialog_opened = true

func _is_dialog_ended():
	is_dialog_opened = false

func _process(delta: float) -> void:
	if can_open_menu and not is_dialog_opened:
		if Input.is_action_just_pressed("change_char"):
			canvas_layer.visible = true
		elif Input.is_action_just_released("change_char"):
			canvas_layer.visible = false

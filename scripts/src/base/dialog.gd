# TextBox.gd
extends Control

@onready var message: RichTextLabel = $CanvasLayer/MarginContainer/Background/message
@onready var npc_name: RichTextLabel = $CanvasLayer/MarginContainer/Background/name
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var skip_button: Button = $CanvasLayer/skip_button
@onready var character_image: TextureRect = $CanvasLayer/CharacterImage

signal textbox_start
signal textbox_end

var dialog_list: Array = []
var current_dialog_index: int = 0
var is_typing: bool = false
var current_text: String = ""
var char_index: int = 0
var typing_speed: float = 0.05
var is_active: bool = false

func _ready() -> void:
	canvas_layer.visible = false
	
	character_image.visible = false
	character_image.anchor_left = 0.0
	character_image.anchor_top = 0.0
	character_image.anchor_right = 1.0
	character_image.anchor_bottom = 1.0
	character_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	character_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	character_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	skip_button.pressed.connect(_on_skipButton_pressed)

func _on_skipButton_pressed():
	end_dialog()

func start_dialog(dialogs: Array, can_skip: bool = false):
	dialog_list = dialogs
	current_dialog_index = 0
	is_active = true
	
	skip_button.visible = can_skip
	
	if dialog_list.size() > 0:
		show_current_dialog()

func show_current_dialog():
	if current_dialog_index < dialog_list.size():
		var dialog = dialog_list[current_dialog_index]
		var image_path = dialog.get("image", "")
		show_text(dialog["name"], dialog["text"], image_path)

func show_text(npc: String, msg: String, image_path: String = ""):
	canvas_layer.visible = true
	npc_name.text = npc
	message.text = ""
	current_text = msg
	char_index = 0
	is_typing = true
	
	if image_path != "" and ResourceLoader.exists(image_path):
		var texture = load(image_path)
		character_image.texture = texture
		character_image.visible = true
	else:
		character_image.visible = false
	
	textbox_start.emit()

func _process(delta: float) -> void:
	if is_typing:
		typing_speed -= delta
		if typing_speed <= 0:
			typing_speed = 0.05 
			
			if char_index < current_text.length():
				message.text += current_text[char_index]
				char_index += 1
			else:
				is_typing = false

func _unhandled_input(event):
	if not is_active or not canvas_layer.visible:
		return
		
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			message.text = current_text
			is_typing = false
		else:
			next_dialog()
		
		get_viewport().set_input_as_handled()

func next_dialog():
	current_dialog_index += 1
	if current_dialog_index < dialog_list.size():
		show_current_dialog()
	else:
		end_dialog()

func end_dialog():
	is_active = false
	canvas_layer.visible = false
	character_image.visible = false
	dialog_list = []
	current_dialog_index = 0
	textbox_end.emit()

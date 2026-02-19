extends Control

@onready var message: RichTextLabel = $CanvasLayer/MarginContainer/Background/message
@onready var npc_name: RichTextLabel = $CanvasLayer/MarginContainer/Background/name
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var skip_button: Button = $CanvasLayer/skip_button
@onready var character_image: TextureRect = $CanvasLayer/CharacterImage
@onready var image_overlay: ColorRect = $CanvasLayer/ImageOverlay

signal textbox_start
signal textbox_end

var dialog_list: Array = []
var current_dialog_index: int = 0
var is_typing: bool = false
var current_text: String = ""
var char_index: int = 0
var typing_speed: float = 0.05
var is_active: bool = false
var current_image_path: String = ""
var fade_duration: float = 0.5

func _ready() -> void:
	canvas_layer.visible = false
	
	character_image.visible = false
	character_image.modulate.a = 0 
	character_image.anchor_left = 0.0
	character_image.anchor_top = 0.0
	character_image.anchor_right = 1.0
	character_image.anchor_bottom = 1.0
	character_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	character_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	character_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	image_overlay.visible = false
	image_overlay.color = Color(0, 0, 0, 1)
	
	skip_button.pressed.connect(_on_skipButton_pressed)

func _on_skipButton_pressed():
	end_dialog()

func start_dialog(dialogs: Array, can_skip: bool = false):
	dialog_list = dialogs
	current_dialog_index = 0
	is_active = true
	current_image_path = ""
	
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
		if current_image_path == image_path and character_image.visible:
			pass
		elif current_image_path != "" and current_image_path != image_path:
			change_character_image(image_path)
		else:
			fade_in_character_image(image_path)
	else:
		if current_image_path != "":
			fade_out_character_image()
	
	textbox_start.emit()

func change_character_image(new_image_path: String):
	var tween = create_tween()
	tween.tween_property(character_image, "modulate:a", 0.0, fade_duration * 0.5)
	tween.tween_callback(func():
		_load_and_fade_in_image(new_image_path)
	)

func _load_and_fade_in_image(image_path: String):
	var texture = load(image_path)
	character_image.texture = texture
	current_image_path = image_path
	fade_in_character_image(image_path)

func fade_in_character_image(image_path: String):
	var texture = load(image_path)
	character_image.texture = texture
	current_image_path = image_path
	
	character_image.visible = true
	character_image.modulate.a = 0.0
	image_overlay.visible = true
	image_overlay.color.a = 1.0
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(character_image, "modulate:a", 1.0, fade_duration)
	tween.tween_property(image_overlay, "color:a", 0.0, fade_duration)
	tween.chain().tween_callback(func():
		image_overlay.visible = false
	)

func fade_out_character_image():
	if not character_image.visible:
		return
	
	image_overlay.visible = true
	image_overlay.color.a = 0.0
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(character_image, "modulate:a", 0.0, fade_duration)
	tween.tween_property(image_overlay, "color:a", 1.0, fade_duration)
	tween.chain().tween_callback(func():
		character_image.visible = false
		image_overlay.visible = false
		current_image_path = ""
	)

func _process(delta: float) -> void:
	var real_delta = delta / Engine.time_scale if Engine.time_scale > 0 else delta  # <-- pakai real delta
	if is_typing:
		typing_speed -= real_delta
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
	fade_out_character_image()
	await get_tree().create_timer(fade_duration).timeout
	canvas_layer.visible = false
	dialog_list = []
	current_dialog_index = 0
	textbox_end.emit()

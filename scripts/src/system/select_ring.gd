extends Control
@onready var change_character: Control = $"../change_character"

@onready var red_ring: Button = $CanvasLayer/MarginContainer/background/RedRing
@onready var yellow_ring: Button = $CanvasLayer/MarginContainer/background/YellowRing
@onready var black_ring: Button = $CanvasLayer/MarginContainer/background/BlackRing
@onready var pink_ring: Button = $CanvasLayer/MarginContainer/background/PinkRing
@onready var blue_ring: Button = $CanvasLayer/MarginContainer/background/BlueRing
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@export var player: BaseCharacter = null
@onready var red_form: CharacterBody2D = $"../Ruby"
@onready var pink_form: CharacterBody2D = $"../Rose"
@onready var black_form: CharacterBody2D = $"../Onyx"
@onready var yellow_form: CharacterBody2D = $"../Topaz"
@onready var blue_form: CharacterBody2D = $"../Sapphire"


func _ready() -> void:
	canvas_layer.visible = false
	var buttons = [red_ring, yellow_ring, black_ring, pink_ring, blue_ring]
	for button in buttons:
		button.pressed.connect(_on_ring_pressed.bind(button.name))
	
	change_character.character_changed.connect(_on_character_changed)
	player = change_character.current_char as BaseCharacter

func _on_ring_pressed(ring_name: String) -> void:
	if not player:
		push_error("Player tidak ter-assign!")
		return
	
	if ring_name == "RedRing":
		await player.transform(red_form)
	elif ring_name == "YellowRing":
		await player.transform(yellow_form)
	elif ring_name == "BlackRing":
		await player.transform(black_form)
	elif ring_name == "PinkRing":
		await player.transform(pink_form)
	elif ring_name == 'BlueRing':
		await player.transform(blue_form)
	
	canvas_layer.visible = false

func _on_character_changed(new_player: BaseCharacter) -> void:
	player = new_player

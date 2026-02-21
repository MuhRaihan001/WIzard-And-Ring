extends Control
@onready var node_2d: Node2D = $".."
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var char_1: Button = $CanvasLayer/char1
@onready var char_2: Button = $CanvasLayer/char2
@onready var han: CharacterBody2D = $"../player"
@onready var rein: CharacterBody2D = $"../Rein"

var current_char: CharacterBody2D
var is_transitioning: bool = false
var target_position: Vector2
var target_char: CharacterBody2D

signal character_changed(new_player: BaseCharacter)
signal main_char(char: BaseCharacter)

const TRANSITION_SPEED: float = 300.0
const TRANSITION_THRESHOLD: float = 5.0

func _ready() -> void:
	char_1.pressed.connect(_on_char1_pressed)
	char_2.pressed.connect(_on_char2_pressed)
	
	current_char = han
	character_changed.emit(han)
	main_char.emit(han)
	_activate_character(han)
	_deactivate_character(rein)

func _on_char1_pressed() -> void:
	if current_char == han or is_transitioning:
		return
	
	if rein.is_transformed and rein.get_current_form() != null:
		han.transform_back(rein.get_current_form())
	
	han.is_attacking = false
	_deactivate_character(rein)
	_start_transition(han.global_position, han)

func _on_char2_pressed() -> void:
	if current_char == rein or is_transitioning:
		return
	
	if han.is_transformed and han.get_current_form() != null:
		han.transform_back(han.get_current_form())
	
	_deactivate_character(han)
	_start_transition(rein.global_position, rein)

func _start_transition(position: Vector2, character: CharacterBody2D) -> void:
	Camera.return_camera_to_normal_state(true)

	canvas_layer.visible = false
	node_2d.can_open_menu = false
	
	if rein.is_transformed:
		rein.transform_back(rein.form)
	
	is_transitioning = true
	target_position = position
	target_char = character

func _process(delta: float) -> void:
	if not is_transitioning:
		return
	
	_update_camera_transition(delta)

func _update_camera_transition(delta: float) -> void:
	var camera = Camera.get_camera()
	if not camera:
		return
	
	var distance: float = camera.global_position.distance_to(target_position)
	
	if distance > TRANSITION_THRESHOLD:
		var direction: Vector2 = (target_position - camera.global_position).normalized()
		camera.global_position += direction * TRANSITION_SPEED * delta
	else:
		_complete_transition()

func _complete_transition() -> void:
	var camera = Camera.get_camera()
	if not camera:
		return
	
	camera.global_position = target_position
	
	var old_char: CharacterBody2D = current_char
	current_char = target_char
	
	_reparent_camera(target_char, old_char)
	
	is_transitioning = false
	node_2d.can_open_menu = true
	character_changed.emit(current_char)
	main_char.emit(current_char)

func _reparent_camera(new_parent: CharacterBody2D, old_parent: CharacterBody2D) -> void:
	var camera = Camera.get_camera()
	if not camera:
		return
	
	var global_pos: Vector2 = camera.global_position
	
	if camera.get_parent():
		camera.get_parent().remove_child(camera)
	
	new_parent.add_child(camera)
	camera.global_position = global_pos
	camera.make_current()
	
	_activate_character(new_parent)
	_deactivate_character(old_parent)

func _activate_character(character: CharacterBody2D) -> void:
	character.set_physics_process(true)
	character.can_move = true

func _deactivate_character(character: CharacterBody2D) -> void:
	character.set_physics_process(false)
	character.velocity = Vector2.ZERO
	character.move_and_slide()
	character.play_idle_animation()
	character.can_move = false

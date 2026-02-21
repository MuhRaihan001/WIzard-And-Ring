extends CharacterBody2D
class_name BaseCharacter

const SPEED: float = 100.0
const RUN_BONUS: float = 50.0
const MAX_HEALTH: float = 100.0

const TRANSFORM_SHAKE_STRENGTH: float = 15.0
const TRANSFORM_SHAKE_DURATION: float = 0.4
const TRANSFORM_ZOOM_SCALE: Vector2 = Vector2(2.5, 2.5)
const TRANSFORM_ZOOM_IN_TIME: float = 0.5
const TRANSFORM_ZOOM_HOLD_TIME: float = 0.8

const TRANSFORM_BACK_SHAKE_STRENGTH: float = 12.0
const TRANSFORM_BACK_SHAKE_DURATION: float = 0.3

enum Direction { DOWN, UP, LEFT, RIGHT, IDLE }

signal radius_range

var is_attacking: bool = false
var can_move: bool = true
var can_transform: bool = false
var is_transformed: bool = false
var current_form: CharacterBody2D = null
var last_direction: Direction = Direction.DOWN
var health: float = MAX_HEALTH

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var change_character: Control = $"../change_character"

func _ready() -> void:
	animated_sprite.play("idle_front")
	animated_sprite.animation_finished.connect(_on_animation_finished)
	TextBox.textbox_start.connect(_on_textbox_start)
	TextBox.textbox_end.connect(_on_textbox_finish)
	_character_ready()

func _character_ready() -> void:
	pass

func _on_textbox_start() -> void:
	can_move = false

func _on_textbox_finish() -> void:
	can_move = true

func _on_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
		play_idle_animation()

func play_idle_animation() -> void:
	match last_direction:
		Direction.LEFT:
			animated_sprite.play("idle_side")
			animated_sprite.flip_h = true
		Direction.RIGHT:
			animated_sprite.play("idle_side")
			animated_sprite.flip_h = false
		Direction.UP:
			animated_sprite.play("idle_back")
		_:
			animated_sprite.play("idle_front")

func play_attack_animation() -> void:
	match last_direction:
		Direction.LEFT:
			animated_sprite.play("attack_side")
			animated_sprite.flip_h = true
		Direction.RIGHT:
			animated_sprite.play("attack_side")
			animated_sprite.flip_h = false
		Direction.UP:
			animated_sprite.play("attack_back")
		_:
			animated_sprite.play("attack_front")

func play_walk_animation(direction: Direction) -> void:
	match direction:
		Direction.LEFT:
			animated_sprite.play("walk_side")
			animated_sprite.flip_h = true
		Direction.RIGHT:
			animated_sprite.play("walk_side")
			animated_sprite.flip_h = false
		Direction.DOWN:
			animated_sprite.play("walk_front")
		Direction.UP:
			animated_sprite.play("walk_back")

func get_input_vector() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func get_direction_from_vector(input_vector: Vector2) -> Direction:
	if input_vector == Vector2.ZERO:
		return Direction.IDLE
	if abs(input_vector.x) >= abs(input_vector.y):
		return Direction.RIGHT if input_vector.x > 0 else Direction.LEFT
	else:
		return Direction.DOWN if input_vector.y > 0 else Direction.UP

func calculate_speed() -> float:
	if Input.is_action_pressed("run") and can_run():
		return SPEED + RUN_BONUS
	return SPEED

func handle_special_input() -> bool:
	return false

func can_attack() -> bool:
	return false

func can_run() -> bool:
	return true

func _physics_process(_delta: float) -> void:
	if not can_move:
		return
	if handle_special_input():
		return
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	if can_attack() and Input.is_action_just_pressed("attack"):
		_start_attack()
		return

	var input_vector: Vector2 = get_input_vector()
	var direction: Direction = get_direction_from_vector(input_vector)

	velocity = input_vector * calculate_speed()

	if direction == Direction.IDLE:
		play_idle_animation()
	else:
		last_direction = direction
		play_walk_animation(direction)

	move_and_slide()

func _start_attack() -> void:
	is_attacking = true
	velocity = Vector2.ZERO
	play_attack_animation()
	move_and_slide()

func allow_transform(option: bool) -> void:
	can_transform = option

func get_current_form() -> CharacterBody2D:
	return current_form

func transform(form: CharacterBody2D) -> void:
	if not form or is_transformed:
		return
	is_transformed = true
	current_form = form
	can_move = false
	form.global_position = global_position
	form.last_direction = last_direction
	if form is BaseForm:
		form._set_current_char(self)
	await _transformation_sequence(form)
	can_move = true

func _transformation_sequence(form: CharacterBody2D) -> void:
	Camera.shake_camera(TRANSFORM_SHAKE_STRENGTH, TRANSFORM_SHAKE_DURATION)
	await get_tree().create_timer(TRANSFORM_SHAKE_DURATION).timeout
	_transfer_camera(form)
	form._set_character_active(true)
	change_character.character_changed.emit(form)
	_set_character_active(false)
	await Camera.showcase_zoom(TRANSFORM_ZOOM_SCALE, TRANSFORM_ZOOM_IN_TIME, TRANSFORM_ZOOM_HOLD_TIME)

func transform_back(form: CharacterBody2D = null) -> void:
	if not is_transformed:
		return
	var target_form: CharacterBody2D = form if form else current_form
	if not target_form:
		push_error("transform_back: no valid form to return to")
		return
	can_move = false
	await _transform_back_sequence(target_form)
	can_move = true

func _transform_back_sequence(form: CharacterBody2D) -> void:
	Camera.shake_camera(TRANSFORM_BACK_SHAKE_STRENGTH, TRANSFORM_BACK_SHAKE_DURATION)
	await get_tree().create_timer(TRANSFORM_BACK_SHAKE_DURATION).timeout
	is_transformed = false
	current_form = null
	_sync_position_and_direction(form)
	_set_character_active(true)
	change_character.character_changed.emit(self)
	form._set_character_active(false)
	_transfer_camera(self)
	play_idle_animation()
	await Camera.return_camera_to_normal_state(true)

func _set_character_active(active: bool) -> void:
	set_physics_process(active)
	visible = active
	collision.disabled = not active

func _transfer_camera(target: CharacterBody2D) -> void:
	var camera = Camera.get_camera()
	camera.reparent(target)
	camera.make_current()

func _sync_position_and_direction(from_char: CharacterBody2D) -> void:
	global_position = from_char.global_position
	last_direction = from_char.last_direction

func add_health(amount: float) -> void:
	health = clampf(health + amount, 0.0, MAX_HEALTH)

func take_damage(amount: float) -> void:
	health = clampf(health - amount, 0.0, MAX_HEALTH)

func is_alive() -> bool:
	return health > 0.0

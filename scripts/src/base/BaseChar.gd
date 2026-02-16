extends CharacterBody2D
class_name BaseCharacter

const SPEED = 100.0
const RUN_BONUS = 50.0

var is_attacking: bool = false
var last_direction: String = 'down'
var can_move: bool = true
var can_transform: bool = false
var is_transformed: bool = false
var current_form: CharacterBody2D = null
signal radius_range

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

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
	if last_direction == 'left' or last_direction == 'right':
		animated_sprite.play("idle_side")
		animated_sprite.flip_h = (last_direction == 'left')
	elif last_direction == 'up':
		animated_sprite.play("idle_back")
	else:  # down
		animated_sprite.play("idle_front")

func play_attack_animation() -> void:
	if last_direction == 'left':
		animated_sprite.play("attack_side")
		animated_sprite.flip_h = true
	elif last_direction == 'right':
		animated_sprite.play("attack_side")
		animated_sprite.flip_h = false
	elif last_direction == 'up':
		animated_sprite.play("attack_back")
	else:  # down
		animated_sprite.play("attack_front")

func get_flip_h_for_direction(direction: String) -> bool:
	return direction == 'left'

func play_animation(direction: String) -> void:
	if direction != 'idle':
		last_direction = direction
	
	if direction == 'left' or direction == 'right':
		animated_sprite.play("walk_side")
		animated_sprite.flip_h = get_flip_h_for_direction(direction)
	elif direction == 'down':
		animated_sprite.play('walk_front')
	elif direction == 'up':
		animated_sprite.play('walk_back')
	elif direction == 'idle':
		play_idle_animation()

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	
	return input_vector.normalized()

func get_direction_from_vector(input_vector: Vector2) -> String:
	if input_vector.length() == 0:
		return 'idle'
	
	if abs(input_vector.x) > abs(input_vector.y):
		return 'right' if input_vector.x > 0 else 'left'
	else:
		return 'down' if input_vector.y > 0 else 'up'

func calculate_speed() -> float:
	var total_speed = SPEED
	if Input.is_action_pressed("run") and can_run():
		total_speed += RUN_BONUS
	return total_speed

func handle_special_input() -> bool:
	return false

func can_attack() -> bool:
	return false

func can_run() -> bool:
	return true

func allow_transform(option: bool) -> void:
	can_transform = option

func get_current_form() -> CharacterBody2D:
	return current_form

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

func transform(form: CharacterBody2D) -> void:
	if not form or is_transformed:
		return
	
	is_transformed = true
	current_form = form
	can_move = false  # Disable movement selama transformasi
	
	# Setup form position dan direction
	form.global_position = global_position
	form.last_direction = last_direction
	
	if form is BaseForm:
		form._set_current_char(self)
	
	# Mulai sequence transformasi
	await _transformation_sequence(form)
	
	can_move = true

func _transformation_sequence(form: CharacterBody2D) -> void:
	Camera.shake_camera(15.0, 0.4)
	await get_tree().create_timer(0.4).timeout
	
	_transfer_camera(form)
	form._set_character_active(true)
	_set_character_active(false)

	await Camera.showcase_zoom(Vector2(2.5, 2.5), 0.5, 0.8)

func transform_back(form: CharacterBody2D) -> void:
	if not is_transformed:
		return
	
	can_move = false
	
	await _transform_back_sequence(form)
	can_move = true

func _transform_back_sequence(form: CharacterBody2D) -> void:
	Camera.shake_camera(12.0, 0.3)
	await get_tree().create_timer(0.3).timeout

	is_transformed = false
	current_form = null
	_sync_position_and_direction(form)
	_set_character_active(true)
	form._set_character_active(false)
	
	_transfer_camera(self)
	play_idle_animation()

	await Camera.return_camera_to_normal_state(true)
	
func _physics_process(delta: float) -> void:
	if not can_move:
		return
	
	if handle_special_input():
		return
	
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if can_attack() and Input.is_action_just_pressed("attack"):
		is_attacking = true
		velocity = Vector2.ZERO
		play_attack_animation()
		move_and_slide()
		return
	
	var input_vector = get_input_vector()
	velocity = input_vector * calculate_speed()
	
	var direction = get_direction_from_vector(input_vector)
	play_animation(direction)
	move_and_slide()

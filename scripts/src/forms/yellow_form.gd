extends BaseCharacter
class_name YellowForm

# Dash settings
const DASH_SPEED: float = 400.0
const DASH_DURATION: float = 0.2
const DASH_COOLDOWN: float = 1.0

# After image settings
const AFTER_IMAGE_INTERVAL: float = 0.03 
const AFTER_IMAGE_LIFETIME: float = 0.2 
const AFTER_IMAGE_COLOR: Color = Color(1.0, 0.9, 0.1, 0.6)

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var after_image_timer: float = 0.0

func _character_ready() -> void:
	pass

func can_attack() -> bool:
	return true

func handle_special_input() -> bool:
	if Input.is_action_just_pressed("skill_1") and not is_dashing and dash_cooldown_timer <= 0.0:
		_start_dash()
		return true
	
	if is_dashing:
		return true
	
	return false

func _physics_process(delta: float) -> void:
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

	if is_dashing:
		dash_timer -= delta
		after_image_timer -= delta

		velocity = dash_direction * DASH_SPEED
		move_and_slide()

		if after_image_timer <= 0.0:
			_spawn_after_image()
			after_image_timer = AFTER_IMAGE_INTERVAL

		if dash_timer <= 0.0:
			_end_dash()
		return

	super._physics_process(delta)

func _start_dash() -> void:
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_cooldown_timer = DASH_COOLDOWN
	after_image_timer = 0.0
	collision.disabled = true
	var input_vector = get_input_vector()
	if input_vector != Vector2.ZERO:
		dash_direction = input_vector.normalized()
	else:
		match last_direction:
			Direction.LEFT:  dash_direction = Vector2.LEFT
			Direction.RIGHT: dash_direction = Vector2.RIGHT
			Direction.UP:    dash_direction = Vector2.UP
			_:               dash_direction = Vector2.DOWN

func _end_dash() -> void:
	is_dashing = false
	dash_direction = Vector2.ZERO
	collision.disabled = false
	play_idle_animation()

func _spawn_after_image() -> void:
	var after_image = Sprite2D.new()
	after_image.texture = animated_sprite.sprite_frames.get_frame_texture(
		animated_sprite.animation,
		animated_sprite.get_frame()
	)

	after_image.global_transform = animated_sprite.global_transform
	after_image.flip_h = animated_sprite.flip_h
	after_image.offset = animated_sprite.offset
	after_image.centered = animated_sprite.centered
	after_image.modulate = AFTER_IMAGE_COLOR
	after_image.z_index = z_index

	get_parent().add_child(after_image)

	match last_direction:
		Direction.UP, Direction.DOWN:
			get_parent().move_child(after_image, get_index())

	var tween = get_tree().create_tween()
	tween.tween_property(after_image, "modulate:a", 0.0, AFTER_IMAGE_LIFETIME)
	tween.tween_callback(after_image.queue_free)

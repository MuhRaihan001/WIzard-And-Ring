extends BaseForm
const CLOCK_UP_TIME_SCALE = 0.15
const CLOCK_UP_DURATION = 5.0

var is_clock_up_active = false
var clock_up_timer = 0.0

func _ready() -> void:
	super._ready()
	process_mode = Node.PROCESS_MODE_ALWAYS

func handle_special_input() -> bool:
	if super.handle_special_input():
		return true
	
	if Input.is_action_just_pressed("skill_1"):
		if is_clock_up_active:
			_deactivate_clock_up()
		else:
			_activate_clock_up()
		return true
	
	return false

func _activate_clock_up() -> void:
	is_clock_up_active = true
	clock_up_timer = CLOCK_UP_DURATION
	Engine.time_scale = CLOCK_UP_TIME_SCALE
	animated_sprite.speed_scale = 1.0 / CLOCK_UP_TIME_SCALE

func _deactivate_clock_up() -> void:
	await TextBox.start_dialog([{"name": self.name, "text": "Clock Over"}])
	is_clock_up_active = false
	Engine.time_scale = 1.0
	animated_sprite.speed_scale = 1.0

func _process(delta: float) -> void:
	var real_delta = delta / Engine.time_scale if Engine.time_scale > 0 else delta
	
	if is_clock_up_active:
		clock_up_timer -= real_delta
		if clock_up_timer <= 0.0:
			_deactivate_clock_up()

func calculate_speed() -> float:
	var speed = super.calculate_speed()
	if is_clock_up_active:
		speed /= CLOCK_UP_TIME_SCALE
	return speed

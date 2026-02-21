extends BaseCharacter
class_name BaseForm

var current_char: CharacterBody2D = null
const FORM_SPEED = 150.0 
const FORM_RUN_BONUS = 70.0

func _ready() -> void:
	super._ready()
	
	set_physics_process(false)
	visible = false
	collision.disabled = true

func can_attack() -> bool:
	return true

func can_run() -> bool:
	return true

func _set_current_char(character: CharacterBody2D) -> void:
	current_char = character

func handle_special_input() -> bool:
	if Input.is_action_just_pressed("transform"):
		current_char.transform_back(self)
		return true
	return false

func calculate_speed() -> float:
	var total_speed = FORM_SPEED
	if Input.is_action_pressed("run"):
		total_speed += FORM_RUN_BONUS
	return total_speed


func _process(delta: float) -> void:
	pass

extends BaseCharacter
@onready var form: CharacterBody2D = $"../black_form"

func _character_ready() -> void:
	set_physics_process(false)
	allow_transform(true)

func get_flip_h_for_direction(direction: String) -> bool:
	return direction == 'right'

func can_attack() -> bool:
	return false

func handle_special_input() -> bool:
	if Input.is_action_just_pressed("transform"):
		transform(form)
		return true
	return false

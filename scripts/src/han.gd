extends BaseCharacter

@onready var form: CharacterBody2D = $"../form"

func _character_ready() -> void:
	allow_transform(true)
	Camera.set_camera($"Camera2D")


func can_attack() -> bool:
	return true

#func handle_special_input() -> bool:
	#if Input.is_action_just_pressed("transform"):
		#transform(form)
		#return true
	#return false

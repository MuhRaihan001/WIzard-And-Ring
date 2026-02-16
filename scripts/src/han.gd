extends BaseCharacter

@onready var form: CharacterBody2D = $"../form"

func _character_ready() -> void:
	var dialog = [
		{"name": "Han", "text": "I have magiro ring"},
		{"name": "Rei", "text": "I have shadow magic ring"}
	]
	TextBox.start_dialog(dialog)
	allow_transform(true)
	Camera.set_camera($"Camera2D")


func can_attack() -> bool:
	return true

func handle_special_input() -> bool:
	if Input.is_action_just_pressed("transform"):
		transform(form)
		return true
	return false

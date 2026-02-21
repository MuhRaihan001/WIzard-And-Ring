extends BaseForm

var original_form
var rage_mode: bool = false

func _ready() -> void:
	super._ready()
	change_character.main_char.connect(_on_main_char_changed)
	original_form = change_character.current_char
	
func _on_main_char_changed(char: BaseCharacter) -> void:
	original_form = char

func _activate_rage_mode():
	rage_mode = true

func _deactivate_rage_mode():
	rage_mode = false

func _process(delta: float) -> void:
	if rage_mode:
		if health <= 5:
			_deactivate_rage_mode()
		if original_form:
			original_form.health -= 1

func handle_special_input() -> bool:
	if Input.is_action_just_pressed("skill_1"):
		if rage_mode:
			return false
		_activate_rage_mode()
		return true
	return super.handle_special_input()

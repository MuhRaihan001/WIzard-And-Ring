extends BaseForm
var original_form
var rage_mode: bool = false
var health_drain_timer: float = 0.0
var health_drain_interval: float = 1.0

func _ready() -> void:
	super._ready()
	change_character.main_char.connect(_on_main_char_changed)
	original_form = change_character.current_char
	
func _on_main_char_changed(char: BaseCharacter) -> void:
	original_form = char

func _activate_rage_mode():
	rage_mode = true
	health_drain_timer = 0.0  

func _deactivate_rage_mode():
	rage_mode = false
	original_form.transform_back(self)
	TextBox.start_dialog([{"name": original_form.name, "text": "I'm Exhausted"}])

func _process(delta: float) -> void:
	if rage_mode:
		if original_form.health <= 5:
			_deactivate_rage_mode()
			return
		_set_bonus_damage(10.0)
		if original_form:
			health_drain_timer += delta
			if health_drain_timer >= health_drain_interval:
				health_drain_timer = 0.0
				original_form.health -= 1

func handle_special_input() -> bool:
	if Input.is_action_just_pressed("skill_1"):
		if rage_mode:
			return false
		_activate_rage_mode()
		return true
	return super.handle_special_input()

extends BaseNpc

@onready var player: CharacterBody2D = $"../player"
@onready var change_character: Control = $"../change_character"

const FOLLOW_DISTANCE = 20.0

func _on_npc_ready() -> void:
	$AnimatedSprite2D.play("idle_side")
	change_character.character_changed.connect(_on_character_changed)
	player = change_character.current_char as BaseCharacter

func _on_character_changed(new_player: BaseCharacter) -> void:
	player = new_player

func _physics_process(delta: float) -> void:
	if player == null or is_dialog_active:
		return

	var target_position = player.global_position - Vector2(FOLLOW_DISTANCE, 0)
	var distance = global_position.distance_to(player.global_position)

	if distance > FOLLOW_DISTANCE:
		_move_npc_to_coords(target_position)
	else:
		_face_player()

func _can_interact() -> bool:
	return false

func _interact_with_player() -> void:
	super._interact_with_player()
	var dialog = [
		{"name": "Villager", "text": "Hello traveler!"},
		{"name": "Villager", "text": "Welcome to our village."}
	]
	TextBox.start_dialog(dialog, false)

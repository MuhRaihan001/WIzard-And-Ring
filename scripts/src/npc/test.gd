extends BaseNpc

@onready var player: CharacterBody2D = $"../player"
var target_position: Vector2
var is_moving_to_player: bool = false

func _on_npc_ready() -> void:
	$AnimatedSprite2D.play("idle_side")
	target_position = player.global_position - Vector2(50, 0)
	is_moving_to_player = true

func _physics_process(delta: float) -> void:
	if is_moving_to_player and not is_dialog_active:
		var arrived = _move_npc_to_coords(target_position)
		
		if arrived:
			is_moving_to_player = false
			_face_player()

func _can_interact() -> bool:
	return true

func _interact_with_player() -> void:
	super._interact_with_player()
	var dialog = [
		{"name": "Villager", "text": "Hello traveler!"},
		{"name": "Villager", "text": "Welcome to our village."}
	]
	TextBox.start_dialog(dialog, false)

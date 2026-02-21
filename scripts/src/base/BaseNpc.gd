extends CharacterBody2D
class_name BaseNpc

var health: float = 100.0
var speed: float = 100.0
var player_nearby: CharacterBody2D = null
var is_dialog_active: bool = false
var interaction_cooldown: float = 0.0
var attack_detection_radius: float = 50.0

signal npc_dead

func _ready() -> void:
	_setup_interaction_area()
	_on_npc_ready()
	
	TextBox.textbox_end.connect(_on_dialog_end)
	TextBox.textbox_start.connect(_on_dialog_start)
	npc_dead.connect(_on_npc_dead)

func _process(delta: float) -> void:
	if interaction_cooldown > 0:
		interaction_cooldown -= delta

func _setup_interaction_area() -> void:
	var interaction_area = get_node_or_null("Area2D")
	
	if interaction_area and interaction_area is Area2D:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)
	else:
		push_warning("InteractionArea not found in " + name)

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		player_nearby = body
		body.damage_trigger.connect(_receive_damage)

func _on_body_exited(body: Node2D) -> void:
	if body is BaseCharacter and body == player_nearby:
		if body.damage_trigger.is_connected(_receive_damage):
			body.damage_trigger.disconnect(_receive_damage)
		player_nearby = null

func _receive_damage(total_damage: float) -> void:
	print(total_damage)
	health -= total_damage
	if health <= 0:
		health = 0
		npc_dead.emit()

func _on_npc_ready() -> void:
	pass

func _set_npc_health(health_amount: float) -> void:
	health = health_amount

func _can_interact() -> bool:
	return false

func _unhandled_input(event: InputEvent) -> void:
	if player_nearby and player_nearby is BaseCharacter:
		var distance = global_position.distance_to(player_nearby.global_position)
		
		if event.is_action_pressed("ui_accept") and not is_dialog_active and interaction_cooldown <= 0 and not TextBox.is_active:
			_interact_with_player()
			get_viewport().set_input_as_handled()
		
		if distance <= attack_detection_radius and not _can_interact() and player_nearby.can_attack() and event.is_action_pressed("attack"):
			player_nearby.give_damage()
		
func _on_npc_dead():
	visible = false

func _interact_with_player() -> void:
	print("Interacting with: ", player_nearby.name)
	is_dialog_active = true

func _on_dialog_start():
	if player_nearby:
		_face_player()

func _on_dialog_end():
	is_dialog_active = false
	interaction_cooldown = 0.3

func _face_player() -> void:
	if not player_nearby:
		return
	
	var direction = player_nearby.global_position - global_position
	
	var facing_direction = _get_facing_direction(direction)
	_update_facing(facing_direction)

func _get_facing_direction(direction: Vector2) -> String:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			return "right"
		else:
			return "left"
	else:
		if direction.y > 0:
			return "down"
		else:
			return "up"

func _update_facing(direction: String) -> void:
	var animated_sprite = get_node_or_null("AnimatedSprite2D")
	if animated_sprite and animated_sprite is AnimatedSprite2D:
		match direction:
			"up":
				animated_sprite.play("idle_back")
				animated_sprite.flip_h = false
			"down":
				animated_sprite.play("idle_front")
				animated_sprite.flip_h = false
			"left":
				animated_sprite.play("idle_side")
				animated_sprite.flip_h = true
			"right":
				animated_sprite.play("idle_side")
				animated_sprite.flip_h = false
				
func _move_npc_to_coords(goal: Vector2) -> bool:
	var direction = goal - global_position
	var distance = direction.length()
	
	var arrival_threshold = 5.0
	
	if distance <= arrival_threshold:
		velocity = Vector2.ZERO
		move_and_slide()
		return true
	
	direction = direction.normalized()
	velocity = direction * speed
	
	move_and_slide()
	
	var facing_direction = _get_facing_direction(direction)
	_update_movement_animation(facing_direction)
	
	return false

func _update_movement_animation(direction: String) -> void:
	var animated_sprite = get_node_or_null("AnimatedSprite2D")
	if animated_sprite and animated_sprite is AnimatedSprite2D:
		match direction:
			"up":
				animated_sprite.play("walk_back")
				animated_sprite.flip_h = false
			"down":
				animated_sprite.play("walk_front")
				animated_sprite.flip_h = false
			"left":
				animated_sprite.play("walk_side")
				animated_sprite.flip_h = true
			"right":
				animated_sprite.play("walk_side")
				animated_sprite.flip_h = false

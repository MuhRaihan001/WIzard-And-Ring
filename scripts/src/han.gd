extends BaseCharacter

@onready var red_ring: Button = $"../ring_list/CanvasLayer/MarginContainer/background/RedRing"
@onready var blue_ring: Button = $"../ring_list/CanvasLayer/MarginContainer/background/BlueRing"
@onready var yellow_ring: Button = $"../ring_list/CanvasLayer/MarginContainer/background/YellowRing"
@onready var black_ring: Button = $"../ring_list/CanvasLayer/MarginContainer/background/BlackRing"
@onready var pink_ring: Button = $"../ring_list/CanvasLayer/MarginContainer/background/PinkRing"
@onready var select_ring: CanvasLayer = $"../ring_list/CanvasLayer"

var have_red_ring: bool = true
var have_blue_ring: bool = true
var have_yellow_ring: bool = true
var have_black_ring: bool = true
var have_pink_ring: bool = true

func _character_ready() -> void:
	allow_transform(true)
	have_red_ring = true
	Camera.set_camera($"Camera2D")
	_update_ring_visibility()

func _update_ring_visibility() -> void:
	red_ring.visible = have_red_ring
	blue_ring.visible = have_blue_ring
	yellow_ring.visible = have_yellow_ring
	black_ring.visible = have_black_ring
	pink_ring.visible = have_pink_ring

func can_attack() -> bool:
	return true

func handle_special_input() -> bool:
	if Input.is_action_just_pressed("ui_focus_next"):
		select_ring.visible = not select_ring.visible
		return true
	elif Input.is_action_just_pressed("ui_cancel"):
		select_ring.visible = false
		return true
	return false

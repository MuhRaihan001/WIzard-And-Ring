extends Node
class_name HitBox

@onready var hit_boxes: Area2D = $Hitbox

func _ready() -> void:
	hit_boxes.monitoring = false
	hit_boxes.monitorable = false
	
	hit_boxes.body_entered.connect(_on_hitbox_hit_entity)
	
func enable_hitbox() -> void:
	hit_boxes.monitoring = true
	hit_boxes.monitorable = true

func _on_hitbox_hit_entity():
	hit_boxes.monitoring = true
	hit_boxes.monitorable = true

	
func _process(delta: float) -> void:
	pass

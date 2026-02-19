extends Node

var main_camera: Camera2D = null
var default_position: Vector2 = Vector2.ZERO
var default_zoom: Vector2 = Vector2.ONE
var is_shaking: bool = false

func _ready():
	if main_camera:
		main_camera.enabled = true

func set_camera(camera: Camera2D) -> void:
	main_camera = camera
	if camera:
		camera.make_current()
		default_position = camera.position
		default_zoom = camera.zoom

func move_camera(target_position: Vector2, smooth: bool = true, duration: float = 0.5):
	if not main_camera:
		return
	
	if smooth:
		var tween = create_tween()
		tween.tween_property(main_camera, "position", target_position, duration)
	else:
		main_camera.position = target_position

func move_camera_with_zoom(target_position: Vector2, zoom_level: Vector2, smooth: bool = true, duration: float = 0.5):
	if not main_camera:
		return
	
	if smooth:
		var tween = create_tween()
		tween.set_parallel(true)  # Jalankan animasi position dan zoom bersamaan
		tween.tween_property(main_camera, "position", target_position, duration)
		tween.tween_property(main_camera, "zoom", zoom_level, duration)
	else:
		main_camera.position = target_position
		main_camera.zoom = zoom_level

func return_camera_to_normal_state(smooth: bool = true, duration: float = 0.5):
	if not main_camera:
		return
	
	if smooth:
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(main_camera, "position", default_position, duration)
		tween.tween_property(main_camera, "zoom", default_zoom, duration)
	else:
		main_camera.position = default_position
		main_camera.zoom = default_zoom

func set_default_state(position: Vector2, zoom: Vector2):
	default_position = position
	default_zoom = zoom

func shake_camera(intensity: float = 10.0, duration: float = 0.3):
	if not main_camera or is_shaking:
		return
	
	is_shaking = true
	var original_offset = main_camera.offset
	var shake_count = int(duration / 0.05)
	
	for i in range(shake_count):
		var random_offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		main_camera.offset = original_offset + random_offset
		await get_tree().create_timer(0.05).timeout

	main_camera.offset = original_offset
	is_shaking = false

func showcase_zoom(target_zoom: Vector2 = Vector2(2, 2), zoom_duration: float = 0.4, hold_duration: float = 0.5):
	if not main_camera:
		return
	
	var tween = create_tween()
	tween.tween_property(main_camera, "zoom", target_zoom, zoom_duration)
	await get_tree().create_timer(zoom_duration + hold_duration).timeout

	return_camera_to_normal_state(true, zoom_duration)

func set_zoom(zoom_level: Vector2, smooth: bool = true, duration: float = 0.3):
	if not main_camera:
		return
	
	if smooth:
		var tween = create_tween()
		tween.tween_property(main_camera, "zoom", zoom_level, duration)
	else:
		main_camera.zoom = zoom_level

func get_camera() -> Camera2D:
	return main_camera

func has_camera() -> bool:
	return main_camera != null

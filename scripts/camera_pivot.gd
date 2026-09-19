extends Node3D

const MOUSE_SENSITIVITY : float = 0.005
const VERTICAL_LIMIT : float = 89.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		rotation.x = clamp(rotation.x, deg_to_rad(-VERTICAL_LIMIT), deg_to_rad(VERTICAL_LIMIT))

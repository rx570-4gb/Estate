extends CharacterBody3D

var SPEED : float = 4.0 
var DECELERATION : float = 8.0
var mod_speed : float = 1.0
const JUMP : float = 5.0
@onready var camera_pivot: Node3D = $CameraPivot

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.use_accumulated_input = false


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed('Shift'):
		mod_speed = 1.5
	else:
		mod_speed = 1.0
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP
	var input_dir := Input.get_vector('left', 'right', 'forward', 'down')
	var direction := (camera_pivot.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	direction.y = 0.0
	direction = direction.normalized()
	if direction:
		velocity.x = direction.x * SPEED * mod_speed
		velocity.z = direction.z * SPEED * mod_speed
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION * delta)
		velocity.z = lerp(velocity.z, 0.0, DECELERATION * delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

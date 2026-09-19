extends Node3D

const COMBO_WINDOW : float = 0.6
enum AnimationState {IDLE, ATTAK, ATTAK2 }
var animation_state : int = AnimationState.IDLE
var can_combo: bool = false
var combo_time: float = 0.0

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D

func _ready() -> void:
	# атаки не должны зацикливаться, иначе animation_finished не сработает
	animated_sprite_3d.sprite_frames.set_animation_loop("Attak", false)
	animated_sprite_3d.sprite_frames.set_animation_loop("Attak2", false)
	animated_sprite_3d.animation_finished.connect(_on_animation_finished)
	animated_sprite_3d.play("Idle")

func _process(delta: float) -> void:
	# отсчитываем окно комбо
	if can_combo:
		combo_time += delta
		if combo_time >= COMBO_WINDOW:
			_reset_to_idle()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click"):
		if animation_state == AnimationState.IDLE:
			# первый клик — начало комбо
			animation_state = AnimationState.ATTAK
			can_combo = false
			animated_sprite_3d.play("Attak")
		elif can_combo:
			# первая атака доиграла — второй клик даёт вторую
			can_combo = false
			animation_state = AnimationState.ATTAK2
			animated_sprite_3d.play("Attak2")
		# иначе (во время анимации) — клик игнорируется

func _reset_to_idle() -> void:
	can_combo = false
	combo_time = 0.0
	animation_state = AnimationState.IDLE
	animated_sprite_3d.play("Idle")

func _on_animation_finished() -> void:
	if animation_state == AnimationState.ATTAK:
		# окно комбо открыто
		can_combo = true
		combo_time = 0.0
	else:
		_reset_to_idle()

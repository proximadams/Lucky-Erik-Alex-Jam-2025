extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Angle direction
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	rotation = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Handle jump
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		velocity.x = rotation.z * SPEED * -1
		velocity.z = rotation.x * SPEED

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('restart'):
		_restart_me()

func _restart_me():
	velocity = Vector3(0,0,0)
	position = Vector3(0,3,0)

extends CharacterBody3D

const SPEED = 10.0
const GRAVITY_SPEED = 10.0
const JUMP_VELOCITY = 5.0
const JUMP_CONSTANT_SPEED_TIME = 0.2
const JUMP_GRACE_WINDOW_TIME = 0.2
@export var divePower = 2

var didJumpEarly = false
var numJumpsSoFar = 1
var jumpConstantSpeedTimer = JUMP_GRACE_WINDOW_TIME
var jumpEarlyWindowTimer = JUMP_GRACE_WINDOW_TIME
var secondsSinceOnFloor = 0.0
var isDiving = false

func _physics_process(delta: float) -> void:
	_set_angle()
	_movement(delta)

func _movement(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_SPEED

	if is_on_floor():
		isDiving = false
		secondsSinceOnFloor = 0.0
		jumpConstantSpeedTimer = 0.0
		if jumpEarlyWindowTimer < JUMP_GRACE_WINDOW_TIME and numJumpsSoFar <= 3:
				numJumpsSoFar += 1
		didJumpEarly = (jumpEarlyWindowTimer < JUMP_GRACE_WINDOW_TIME)
		velocity.y = JUMP_VELOCITY
		velocity.x = (rotation.z * SPEED * -0.7) + (velocity.x * 0.3)
		velocity.z = (rotation.x * SPEED * 0.7) + (velocity.z * 0.3)
	elif isDiving: # we are NOT diving i we're on the floor
		velocity.y = -JUMP_VELOCITY * divePower
		velocity.x = (rotation.z * SPEED * -0.7) + (velocity.x * 0.3)
		velocity.z = (rotation.x * SPEED * 0.7) + (velocity.z * 0.3)
	secondsSinceOnFloor += delta
	
	if jumpConstantSpeedTimer < JUMP_CONSTANT_SPEED_TIME * numJumpsSoFar:
		jumpConstantSpeedTimer += delta
		velocity.y = JUMP_VELOCITY
	if JUMP_CONSTANT_SPEED_TIME <= jumpConstantSpeedTimer and not didJumpEarly and jumpConstantSpeedTimer <= secondsSinceOnFloor:
		numJumpsSoFar = 1

	if jumpEarlyWindowTimer < JUMP_GRACE_WINDOW_TIME:
		jumpEarlyWindowTimer += delta

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('restart'):
		_restart_me()
	if not event.is_echo() and event.is_action_pressed('jump'):
		if jumpConstantSpeedTimer < JUMP_GRACE_WINDOW_TIME and numJumpsSoFar <= 3:
			numJumpsSoFar += 1
		else:
			jumpEarlyWindowTimer = 0.0
	
	if not event.is_echo() and event.is_action_pressed('dive'): # do the dive
		isDiving = true;

# This is purely a debug function. Delete it later
func _restart_me():
	velocity = Vector3(0,0,0)
	position = Vector3(0,3,0)

# Angle the player based on the stick/arrows
func _set_angle():
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	rotation = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

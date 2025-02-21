extends CharacterBody3D
enum {
	GROUNDED, # on the ground.
	BOUNCING, # air, did not use a jump.
	PRE_JUMP, # grounded but going to jump
	JUMPING, # air, did use a jump
	DIVING, # air, used dive
	HIT, # got hit
	STUCK,
}
var state = GROUNDED

@export var bounceVelocity = 10
@export var jumpVelocity = 20
@export var diveVelocity = 45

var bounceSmall1SoundRes = load('res://SoundEffects/BounceSmall1Sound.tscn')

const SPEED = 10.0
const GRAVITY_SPEED = 10.0
const JUMP_VELOCITY = 5.0
const JUMP_GRACE_WINDOW_TIME = 0.4
const MAX_JUMPS = 3

var didJumpEarly = false
var numJumpsSoFar = 0
var jumpEarlyWindowTimer = 0
var oldAirVelocity = Vector3(0,0,0)
var oldIsOnFloor = false # did we just land????

@export var playerID = 0
var MAX_GROUND_TIME = 0.2
var MAX_STUCK_TIME = 0.5
var currGroundTime = 0;
var currAirTime = 0;

func _physics_process(delta: float) -> void:
	_set_angle()
	_movement(delta)

func _movement(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_SPEED
		oldAirVelocity = velocity

	if is_on_floor():
		velocity = Vector3(0,0,0)
		currGroundTime += delta
		jumpEarlyWindowTimer += delta
		didJumpEarly = (jumpEarlyWindowTimer < JUMP_GRACE_WINDOW_TIME)

		if state != GROUNDED and state != STUCK:
			$AnimationPlayer.play('SquishJump')
			add_child(bounceSmall1SoundRes.instantiate())

		if state == DIVING:
			state = STUCK
		
		if state == PRE_JUMP && didJumpEarly:
			state = JUMPING
			numJumpsSoFar += 1
			_calc_jumping_velocity()
			currGroundTime = 0
		elif (state == GROUNDED and currGroundTime >= MAX_GROUND_TIME) or (state == STUCK and currGroundTime >= MAX_STUCK_TIME):
			state = BOUNCING
			numJumpsSoFar = 0
			currGroundTime = 0
			_calc_bouncing_velocity()
		elif state != STUCK:
			state = GROUNDED
			_calc_grounded_velocity()
	elif state == DIVING:
		_calc_diving_velocity()

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('restart.' + str(playerID)):
		_restart_me()
	if not event.is_echo() and event.is_action_pressed('jump.' + str(playerID)) and state != STUCK:
		state = PRE_JUMP
		jumpEarlyWindowTimer = 0.0

	if not event.is_echo() and event.is_action_pressed('dive.' + str(playerID)) and not is_on_floor(): # do the dive
		state = DIVING

# This is purely a debug function. Delete it later
func _restart_me():
	velocity = Vector3(0,0,0)
	position = Vector3(0,3,0)

# Angle the player based on the stick/arrows
func _set_angle():
	var input_dir := Input.get_vector('move_left.' + str(playerID), 'move_right.' + str(playerID), 'move_up.' + str(playerID), 'move_down.' + str(playerID))
	rotation = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

# awful function.
func _calc_jumping_velocity():
	velocity.x = (rotation.z * -jumpVelocity)
	velocity.y = jumpVelocity
	velocity.z = (rotation.x * jumpVelocity)

# x/z swap is intentional
func _calc_bouncing_velocity():
	velocity.x = (rotation.z * -bounceVelocity)
	velocity.y = bounceVelocity
	velocity.z = (rotation.x * bounceVelocity)
	
func _calc_grounded_velocity():
	velocity.x = ((rotation.z * SPEED * -0.7) + (velocity.x * 0.3)) *.5
	velocity.z = ((rotation.x * SPEED * 0.7) + (velocity.z * 0.3)) *.5

func _calc_diving_velocity():
	velocity.y = -diveVelocity
	velocity.x = (-rotation.z * diveVelocity)
	velocity.z = (-rotation.x * diveVelocity)

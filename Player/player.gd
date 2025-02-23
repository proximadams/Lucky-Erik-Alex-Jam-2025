extends CharacterBody3D
class_name PogoPlayer
enum {
	DEAD,
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
@export var colour: Color
@export var diveVelocity = 45
@export var floorPath: NodePath
@export var jumpVelocity = 24
@export var playerID = 0
@export var explosionScene: PackedScene

const GRAVITY_SPEED = 5.0
const JUMP_GRACE_WINDOW_TIME = 0.1
const MAX_JUMPS = 3
const MAX_GROUND_TIME = 0.1
const MAX_STUCK_TIME = 0.5
const SPEED = 10.0
const SPEED_MULT_SHALLOW_BOUNCE = 1.5
const SPEED_MULT_JUMP = 0.5
const VOLUME_SILENT = -80.0
const VOLUME_NOTE_LOUD = 0.0

var didJumpEarly = false
var numJumpsSoFar = 0
var jumpEarlyWindowTimer = 0
var oldAirVelocity = Vector3(0,0,0)
var oldIsOnFloor = false # did we just land????
var playerOpponent
var hitPercent = 0.0

var currGroundTime = 0;
var currAirTime = 0;

var MAX_HIT_TIME = 0.5
var currHitTime = 0
var lastHitVector: Vector3 = Vector3(0,0,0)

@onready var floorInst = get_node(floorPath)

signal player_died(playerID: int)
signal player_percent_changed(playerID: int, percent: float)

func _ready() -> void:
	_set_hitbox(false)
	$SM_PogoStick/pogo_purple.visible = (playerID == 0)
	$SM_PogoStick/pogo_yellow.visible = (playerID != 0)

func _physics_process(delta: float) -> void:
	_set_angle()
	if position.y < -5:
		_die()
	if position.y < -50 and is_instance_valid(floorInst):
		_restart_me()
	_movement(delta)
	_note_bounce_volumes()
	move_and_slide()

func _movement(delta: float):
	# Add the gravity.
	if state == HIT:
		currHitTime += delta
		if (currHitTime < MAX_HIT_TIME):
			_calc_hit_velocity()
			return
		else:
			currHitTime = 0
			state = BOUNCING
	
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_SPEED
		oldAirVelocity = velocity

	if is_on_floor():
		_set_hitbox(false)
		velocity = Vector3(0,0,0)
		currGroundTime += delta
		jumpEarlyWindowTimer += delta
		didJumpEarly = (jumpEarlyWindowTimer < JUMP_GRACE_WINDOW_TIME)

		if state != GROUNDED and state != STUCK:
			$AnimationPlayer.play('SquishJump')
			$BounceSmall1Sound.play()
			$Note1Sound.play()
			$Note2Sound.play()
			$Note3Sound.play()

		if state == DIVING:
			state = STUCK
		
		if state == PRE_JUMP and didJumpEarly:
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

func _input(event: InputEvent) -> void:
	if not event.is_echo() and event.is_action_pressed('jump.' + str(playerID)) and state != STUCK:
		state = PRE_JUMP
		jumpEarlyWindowTimer = 0.0

	if state != DEAD and state != HIT and not event.is_echo() and event.is_action_pressed('dive.' + str(playerID)) and not is_on_floor(): # do the dive
		state = DIVING
		_set_hitbox(true)

func _note_bounce_volumes():
	var barTime = MusicPlayer.get_child(0).get_playback_position()
	var secondsInBar = 1.3333333
	while 5.3333333 < barTime:
		barTime -= 5.3333333
	if barTime < secondsInBar:
		$Note1Sound.volume_db = VOLUME_NOTE_LOUD
		$Note2Sound.volume_db = VOLUME_SILENT
		$Note3Sound.volume_db = VOLUME_SILENT
	elif barTime < secondsInBar * 2:
		$Note1Sound.volume_db = VOLUME_SILENT
		$Note2Sound.volume_db = VOLUME_NOTE_LOUD
		$Note3Sound.volume_db = VOLUME_SILENT
	elif barTime < secondsInBar * 3:
		$Note1Sound.volume_db = VOLUME_NOTE_LOUD
		$Note2Sound.volume_db = VOLUME_SILENT
		$Note3Sound.volume_db = VOLUME_SILENT
	elif barTime < secondsInBar * 4:
		$Note1Sound.volume_db = VOLUME_SILENT
		$Note2Sound.volume_db = VOLUME_SILENT
		$Note3Sound.volume_db = VOLUME_NOTE_LOUD
	else:
		$Note1Sound.volume_db = VOLUME_NOTE_LOUD
		$Note2Sound.volume_db = VOLUME_SILENT
		$Note3Sound.volume_db = VOLUME_SILENT

func _die():
	if state != DEAD:
		state = DEAD
		player_died.emit(playerID)
		$YellSound.stream = Global.get_random_yell_sound()
		$YellSound.play()

func _restart_me():
	velocity = Vector3(0,0,0)
	position = Vector3(Global.rng.randf_range(-0.1, 0.1),3,Global.rng.randf_range(-0.1, 0.1))
	hitPercent = 0.0
	player_percent_changed.emit(playerID, hitPercent)

# Angle the player based on the stick/arrows
func _set_angle():
	var input_dir := Input.get_vector('move_left.' + str(playerID), 'move_right.' + str(playerID), 'move_up.' + str(playerID), 'move_down.' + str(playerID))
	rotation = transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	if state == DIVING:
		rotation.x *= -1
		rotation.z *= -1

# awful function.
func _calc_jumping_velocity():
	velocity.x = (rotation.z * -jumpVelocity * SPEED_MULT_JUMP)
	velocity.y = jumpVelocity
	velocity.z = (rotation.x * jumpVelocity * SPEED_MULT_JUMP)

# x/z swap is intentional
func _calc_bouncing_velocity():
	velocity.x = (rotation.z * -bounceVelocity * SPEED_MULT_SHALLOW_BOUNCE)
	velocity.y = bounceVelocity
	velocity.z = (rotation.x * bounceVelocity * SPEED_MULT_SHALLOW_BOUNCE)
	
func _calc_grounded_velocity():
	velocity.x = ((rotation.z * SPEED * -0.7) + (velocity.x * 0.3)) *.5
	velocity.z = ((rotation.x * SPEED * 0.7) + (velocity.z * 0.3)) *.5

func _calc_diving_velocity():
	velocity.y = -diveVelocity
	velocity.x = (rotation.z * diveVelocity)
	velocity.z = (-rotation.x * diveVelocity)
	if playerOpponent.global_position.x < global_position.x \
		and global_position.x - 10.0 < playerOpponent.global_position.x:
			velocity.x -= 10.0
	elif global_position.x < playerOpponent.global_position.x \
		and playerOpponent.global_position.x < global_position.x + 10.0:
			velocity.x += 10.0
	if playerOpponent.global_position.z < global_position.z \
		and global_position.z - 10.0 < playerOpponent.global_position.z:
			velocity.z -= 10.0
	elif global_position.z < playerOpponent.global_position.z \
		and playerOpponent.global_position.z < global_position.z + 10.0:
			velocity.z += 10.0

func _calc_hit_velocity():
	velocity = lastHitVector

func _on_hurtbox_area_entered(area: Area3D) -> void:
	var groups = area.get_groups()
	if groups.find("Hitbox") != -1 and area.get_parent_node_3d().name != $Hitbox.get_parent_node_3d().name:
		state = HIT
		hitPercent += Global.rng.randf_range(0.05, 0.2)
		player_percent_changed.emit(playerID, hitPercent)
		$Hitbox.set_deferred("monitorable", false)
		var hitVelocity = area.get_parent_node_3d().velocity * hitPercent
		lastHitVector = Vector3(hitVelocity.x, -hitVelocity.y,hitVelocity.z)
		var explosionInstance = explosionScene.instantiate()
		explosionInstance.position = position
		explosionInstance.position.y -= .5
		get_tree().get_root().add_child(explosionInstance)
		
func _set_hitbox(x: bool):
	$Hitbox.monitorable = x

func is_hitbox_on():
	return $Hitbox.monitorable

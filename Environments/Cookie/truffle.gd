extends Node3D

const MIN_HURT_DISTANCE = 3.0

@onready var player0 = get_parent().find_child('Player_0')
@onready var player1 = get_parent().find_child('Player_1')

var isDisabledP0 = false
var isDisabledP1 = false

@export var timeOffset = 0.0

func _ready():
	$AnimationPlayer.seek(timeOffset)

func _process(_delta: float) -> void:
	if not isDisabledP0 and $TruffleNode3D.global_position.distance_to(player0.global_position) < MIN_HURT_DISTANCE:
		player0.handle_truffle_hit()
		isDisabledP0 = true
	if not isDisabledP1 and $TruffleNode3D.global_position.distance_to(player1.global_position) < MIN_HURT_DISTANCE:
		player1.handle_truffle_hit()
		isDisabledP1 = true

func set_random_position():
	global_position.x = Global.rng.randf_range(-10.33, 10.33)
	global_position.z = Global.rng.randf_range(-10.33, 10.33)
	isDisabledP0 = false
	isDisabledP1 = false

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.name == 'Hurtbox':
		area.get_parent()._on_hurtbox_area_entered($Node3D/Area3D)

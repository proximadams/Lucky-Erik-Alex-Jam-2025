extends Node3D

var roundFinishedTimerRes: PackedScene = load('res://Environments/RoundFinishedTimer.tscn')

const ROUND_TIME = 30.0

var currentRound = 1
var numDeathsArr = [0, 0]
var timeRemaining = ROUND_TIME

@export var nextRoundScene = ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _res = $Player_0.connect('player_died', player_died)
	_res = $Player_1.connect('player_died', player_died)
	_res = $Player_0.connect('player_percent_changed', player_percent_changed)
	_res = $Player_1.connect('player_percent_changed', player_percent_changed)
	$Player_0.playerOpponent = $Player_1
	$Player_1.playerOpponent = $Player_0

func player_died(playerID: int) -> void:
	if 0 <= playerID and playerID < numDeathsArr.size():
		numDeathsArr[playerID] += 1
		var textStr = 'P' + str(playerID) + ' Deaths = ' + str(numDeathsArr[playerID])
		$HUD.get_child(playerID).find_child('DeathsLabel', false).text = textStr

func player_percent_changed(playerID: int, percent: float) -> void:
	var percentInt = round(percent * 100.0)
	$HUD.get_child(playerID).find_child('PercentLabel', false).text = str(percentInt) + '%'

func game_over():
	var roundPrefix = 'Round ' + str(currentRound) + ': '
	$HUD/WinnerLabel.visible = true
	if numDeathsArr[0] < numDeathsArr[1]:
		$HUD/WinnerLabel.text = roundPrefix + 'Player 0 Wins!'
	elif numDeathsArr[0] > numDeathsArr[1]:
		$HUD/WinnerLabel.text = roundPrefix + 'Player 1 Wins!'
	else:
		$HUD/WinnerLabel.text = roundPrefix + 'TIE!'
	Global.numDeathsTotalArr[0] += numDeathsArr[0]
	Global.numDeathsTotalArr[1] += numDeathsArr[1]
	var roundFinishedTimerInst = roundFinishedTimerRes.instantiate()
	add_child(roundFinishedTimerInst)
	roundFinishedTimerInst.nextRoundScene = nextRoundScene
	get_tree().paused = true

func _process(delta: float) -> void:
	if timeRemaining <= 0.0:
		timeRemaining = 0.0
		game_over()
	else:
		timeRemaining -= delta
	$HUD/TimeBar.scale.x = timeRemaining / ROUND_TIME

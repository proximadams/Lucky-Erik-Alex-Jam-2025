extends Node3D

var numDeathsArr = [0, 0]

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
	$HUD/WinnerLabel.visible = true
	if numDeathsArr[0] < numDeathsArr[1]:
		$HUD/WinnerLabel.text = 'Player 0 Wins!'
	elif numDeathsArr[0] > numDeathsArr[1]:
		$HUD/WinnerLabel.text = 'Player 1 Wins!'
	else:
		$HUD/WinnerLabel.text = 'TIE!'

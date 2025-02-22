extends Node3D

var numDeathsArr = [0, 0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _res = $Player_0.connect('player_died', player_died)
	_res = $Player_1.connect('player_died', player_died)

func player_died(playerID: int):
	if 0 <= playerID and playerID < numDeathsArr.size():
		var nodeName = 'P' + str(playerID) + 'DeathsLabel'
		numDeathsArr[playerID] += 1
		var textStr = 'P' + str(playerID) + ' Deaths = ' + str(numDeathsArr[playerID])
		$HUD.find_child(nodeName, false).text = textStr

func game_over():
	$HUD/WinnerLabel.visible = true
	if numDeathsArr[0] < numDeathsArr[1]:
		$HUD/WinnerLabel.text = 'Player 0 Wins!'
	elif numDeathsArr[0] > numDeathsArr[1]:
		$HUD/WinnerLabel.text = 'Player 1 Wins!'
	else:
		$HUD/WinnerLabel.text = 'TIE!'

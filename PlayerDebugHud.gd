extends VBoxContainer
@export var player: PogoPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$StateLabel.text = "State:" +str(player.state)
	$GroundLabel.text = "Ground:" +str(player.currGroundTime)
	$AirLabel.text = "Air:" +str(player.currAirTime)
	$HitLabel.text = "Hit:" +str(player.currHitTime)
	$HitBoxLabel.text = "Hit Monitorable:" +str(player.is_hitbox_on())

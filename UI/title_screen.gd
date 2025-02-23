extends CanvasLayer

func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file('res://Environments/Hoodoo/Round1.tscn')

func refresh_controller_instructions():
	$Controls/ControlsTextureRect0.visible = (Global.numDevicesConnected == 0)
	$Controls/ControlsTextureRect1.visible = (Global.numDevicesConnected == 1)
	$Controls/ControlsTextureRect2.visible = (Global.numDevicesConnected == 2)

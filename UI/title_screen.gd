extends CanvasLayer

func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file('res://Environments/Hoodoo/Round1.tscn')

func _on_show_settings() -> void:
	PauseMenu.toggle_pause()

func one_layer_deeper_back_stack() -> void:
	Global.instantExitEnabled = false

func _input(event: InputEvent) -> void:
	if event.is_action_released('quit') and $Controls.visible:
		Global.set_deferred('instantExitEnabled', true)
		$Controls.set_visible(false)
		$VBoxContainer/ControlsButton.grab_focus()

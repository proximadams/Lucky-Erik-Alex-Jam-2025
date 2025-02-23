extends CanvasLayer

func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file('res://Environments/Hoodoo/Round1.tscn')

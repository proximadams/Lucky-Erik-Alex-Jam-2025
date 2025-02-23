extends Control

func _ready() -> void:
	$VBoxContainer/PlayAgainButton.grab_focus()
	$VictoryContainer/WinnerLabel.text = Global.get_winner()
	get_tree().paused = false

func _on_play_again_button_pressed() -> void:
	get_tree().change_scene_to_file('res://Environments/Hoodoo/Round1.tscn')

func _on_title_button_pressed() -> void:
	get_tree().change_scene_to_file('res://UI/TitleScreen.tscn')

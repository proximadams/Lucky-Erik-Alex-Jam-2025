extends CanvasLayer

var titleScene = 'res://UI/TitleScreen.tscn'

var prevFocus = null

@onready var tree = get_tree()

func _ready() -> void:
	visible = false

func set_music_volume(value: float) -> void:
	Global.set_music_volume(value / 100.0)
	Global.save_setting_music_volume()

func set_sfx_volume(value: float) -> void:
	Global.set_sfx_volume(value / 100.0)
	Global.save_setting_sfx_volume()

func grab_focus_slider() -> void:
	$Control/VBoxContainer/HBoxContainerMusic/HSlider.grab_focus()

func unpause() -> void:
	if is_instance_valid(prevFocus):
		prevFocus.grab_focus()
	tree.paused = false
	visible = false

func _pause() -> void:
	visible = true
	tree.paused = true
	prevFocus = tree.get_root().gui_get_focus_owner()
	grab_focus_slider()
	$Control/VBoxContainer/HBoxContainerMusic/HSlider.value = Global.musicVolume * 100.0
	$Control/VBoxContainer/HBoxContainerSFX/HSlider.value = Global.sfxVolume * 100.0

func toggle_pause() -> void:
	if visible:
		unpause()
	else:
		_pause()

func _input(event: InputEvent) -> void:
	if not event.is_echo() and event.is_action_pressed('pause'):
		toggle_pause()

func go_to_title_screen() -> void:
	tree.change_scene_to_file(titleScene)
	unpause()

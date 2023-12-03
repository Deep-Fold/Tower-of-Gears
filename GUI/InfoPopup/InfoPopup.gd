extends Control

onready var label = $Border/Inner/Label
var lines = []
var line_index = 0
var showing_line = false

func _do_popup_line(texts):
	label.text = texts[0]
	lines = texts
	line_index = 0
	label.visible_characters = 0
	$RevealFrequency.start()
	$AnimationPlayer.play("popup")
	showing_line = true

func _on_RevealFrequency_timeout():
	label.visible_characters += 1
	if label.visible_characters < label.get_total_character_count():
		$RevealFrequency.start()

func is_showing_line():
	return showing_line

func _progress_line():
	if label.visible_characters == -1 || label.visible_characters >= label.get_total_character_count():
		line_index += 1
		if line_index >= lines.size():
			$AnimationPlayer.play_backwards("popup")
			showing_line = false
		else:
			$RevealFrequency.start()
			label.text = lines[line_index]
			label.visible_characters = 0
	else:
		label.visible_characters = -1
		$RevealFrequency.stop()

func _on_Inner_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if event.button_index == 1:
			_progress_line()

func _on_Label_gui_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if event.button_index == 1:
			_progress_line()

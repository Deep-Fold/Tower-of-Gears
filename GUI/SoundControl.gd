extends Control

signal change_time_enabled

var music = true
var sound = true
var time = true

var sound_index = 1
var music_index = 1

func _ready():
	sound_index = AudioServer.get_bus_index("sound")
	music_index = AudioServer.get_bus_index("music")

func _on_MusicButton_pressed():
	music = !music
	
	if music:
		$MusicButton.modulate.a = 1.0
		AudioServer.set_bus_volume_db(music_index, 0)
	else:
		$MusicButton.modulate.a = 0.5
		AudioServer.set_bus_volume_db(music_index, -80)

func _on_SoundButton_pressed():
	sound = !sound

	if sound:
		$SoundButton.modulate.a = 1.0
		AudioServer.set_bus_volume_db(sound_index, 0)
	else:
		$SoundButton.modulate.a = 0.5
		AudioServer.set_bus_volume_db(sound_index, -80)

func _on_TimeButton_pressed():
	time = !time
	emit_signal("change_time_enabled", time)
	
	if time:
		$TimeButton.modulate.a = 1.0
	else:
		$TimeButton.modulate.a = 0.5

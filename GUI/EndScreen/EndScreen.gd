extends Control

signal restart
var won = true

func play_win():
	$AnimationPlayer.play("win")
	won = true

func play_lose():
	$AnimationPlayer.play("lose")
	won = false


func _on_Button_pressed():
	emit_signal("restart")
	if won:
		$AnimationPlayer.play_backwards("win")
	else:
		$AnimationPlayer.play_backwards("lose")

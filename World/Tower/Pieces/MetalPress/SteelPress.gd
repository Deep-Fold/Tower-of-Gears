extends "res://World/Tower/Pieces/ProducePiece.gd"

func get_input_items():
	return [{
		"code": item_list.items.IRON_SHEET,
		"amount": 2
	}]

func get_output_item():
	return item_list.items.STEEL_SHEET

func _produce_item():
	._produce_item()
	$Audio.play()
	_release_embers(0.4)
	_add_small_smoke()
	$AnimationPlayer.play("press")
	$PlayRelease.start()


func _on_PlayRelease_timeout():
	$AnimationPlayer.play("release")

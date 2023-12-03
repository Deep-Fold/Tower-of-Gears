extends "res://World/Tower/Pieces/ProducePiece.gd"

func get_input_items():
	return [{
		"code": item_list.items.STONE,
		"amount": 3
	}]

func get_output_item():
	return item_list.items.BRICK

func _produce_item():
	._produce_item()
	$AnimationPlayer.play("saw")
	$Audio.play()
	_release_embers(0.5)
	_add_small_smoke()

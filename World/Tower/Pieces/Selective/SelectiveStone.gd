extends "res://World/Tower/Pieces/ProducePiece.gd"

func get_input_items():
	return [{
		"code": item_list.items.STONE,
		"amount": 1
	}]

func get_output_item():
	return item_list.items.STONE

func _produce_item():
	._produce_item()
	$Audio.play()
	if rand_range(0.0, 1.0) > 0.9:
		_add_small_smoke()
	_release_embers(0.05)

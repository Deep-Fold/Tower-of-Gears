extends "res://World/Tower/Pieces/ProducePiece.gd"

func get_input_items():
	return [{
		"code": item_list.items.CRUDE_OIL,
		"amount": 5
	}]

func get_output_item():
	return item_list.items.REFINED_OIL

func _produce_item():
	._produce_item()
	$Audio.play()
	_release_embers(0.2)
	_add_small_smoke()

extends "res://World/Tower/Pieces/ProducePiece.gd"

func get_input_items():
	return [{
		"code": item_list.items.REFINED_OIL,
		"amount": 2
	}
	]

func get_output_item():
	return item_list.items.CARBON

func _produce_item():
	._produce_item()
	$AnimationPlayer.play("sparks")
	$Audio.play()
	_release_embers(0.2)
	_add_small_smoke()

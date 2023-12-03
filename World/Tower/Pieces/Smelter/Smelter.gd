extends "res://World/Tower/Pieces/ProducePiece.gd"

func get_input_items():
	return [{
		"code": item_list.items.IRON_ORE,
		"amount": 3
	}]

func get_output_item():
	return item_list.items.MELTED_IRON

func _produce_item():
	._produce_item()
	$Audio.play()
	_release_embers(0.5)
	$AnimatedSprite.animation = "activate"
	$AnimationTimer.start()
	for i in 2:
		_add_big_smoke()


func _on_AnimationTimer_timeout():
	$AnimatedSprite.animation = "idle"

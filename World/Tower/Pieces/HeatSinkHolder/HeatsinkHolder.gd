extends "res://World/Tower/Pieces/InputOutputPiece.gd"

func _produce_step():
	if storage != null:
		if storage.heat_capacity >= 1.0:
			_eject(storage)
			storage = null

func _eject(item):
	item.free_fall()
	item.velocity = (output_vectors[0]*rand_range(200, 300)).rotated(rand_range(-0.4, 0.4))
	
	_add_big_smoke(Vector2(0, rand_range(-15,-20)))
	_release_embers(0.4)
	$Audio.play()

func _next_produce_step(index):
	._next_produce_step(index)
	_take_from_input_selective()

func _take_from_input_selective():
	if storage == null:
		for i in take_from.size():
			if take_from[i] != null:
				if take_from[i].has_item() && take_from[i].storage.item_code == item_list.items.HEATSINK:
					var item = take_from[i].pop_item()
					call_deferred("set_storage", item) # call 1 frame later so item doesnt get transported instantly across all transporters
					_animate_item_movement(item)

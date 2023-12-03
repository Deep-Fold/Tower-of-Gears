extends "res://World/Tower/Pieces/ProducePiece.gd"

var heat_sink_scene = preload("res://World/Tower/Item/heatsink/HeatSink.tscn")

func get_input_items():
	return []

func get_output_item():
	return item_list.items.HEATSINK

func _produce_item():
	if storage == null:
		$Audio.play()
		_release_embers(0.5)
		_add_small_smoke()
		
		var item = heat_sink_scene.instance()
		storage = item
		item.set_item_code(output_item)
		get_parent().add_child(item)
		item.global_position = global_position
		
		for i in input_storage:
			i.queue_free()
		input_storage = []

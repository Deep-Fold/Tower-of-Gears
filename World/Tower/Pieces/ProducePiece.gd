extends "res://World/Tower/Pieces/InputOutputPiece.gd"

onready var item_scene = preload("res://World/Tower/Item/Item.tscn")

var input_storage = [] # what piece currently has
var input_items = [] # what is required
var output_item = null

func _ready():
	input_items = get_input_items()
	output_item = get_output_item()

func destroy_storage():
	.destroy_storage()
	for i in input_storage:
		if i != null:
			i.queue_free()

func _next_produce_step(index):
	._next_produce_step(index)
	if storage == null:
		_take_from_input_selective()

func _take_from_input_selective():
	for i in take_from.size():
		var neighbour = take_from[i]
		if take_from[i] != null:
			if neighbour.has_item():
				if neighbour.is_in_group("source"):
					for s in input_items:
						if _need_item_with_code(s.code) && neighbour._have_in_storage(s.code):
							var item = neighbour._get_by_code(s.code)
							input_storage.append(item)
							_animate_item_movement(item)
							return # end so we dont take multiple items in 1 step
				else:
					if _need_item_with_code(neighbour.storage.item_code):
						var item = neighbour.pop_item()
						#call_deferred("set_storage", item) # call 1 frame later so item doesnt get transported instantly across all transporters
						input_storage.append(item)
						_animate_item_movement(item)
						return # end so we dont take multiple items in 1 step

func _produce_step():
	if _have_all_for_produce():
		_produce_item()

func _need_item_with_code(item_code):
	for i in input_items: # check if item is required
		if i.code == item_code && _amount_in_storage(item_code) < _amount_required(item_code):
			return true

func _amount_required(item_code):
	for i in input_items:
		if i.code == item_code:
			return i.amount
	return 0

func _amount_in_storage(item_code):
	var count = 0
	for i in input_storage:
		if i.item_code == item_code:
			count +=1
	return count

func _have_all_for_produce():
	for i in input_items: # check if item is required
#		for s in input_storage:
#			var i_code = s.item_code
#			if i_code == i.code:
		if _amount_in_storage(i.code) < _amount_required(i.code):
			return false
	return true
#	for i in input_items:
#		var have = false
#		for s in input_storage:
#			if s.code == i.code:
#				have = true
#		if have == false:
#			return false
#
#	return true

func _produce_item():
	var item = item_scene.instance()
	storage = item
	item.set_item_code(output_item)
	get_parent().add_child(item)
	item.global_position = global_position
	
	for i in input_storage:
		i.queue_free()
	input_storage = []

func get_output_item():
	return null

func get_input_items():
	return []

extends "res://World/Tower/Pieces/MachinePiece.gd"

export var input_vectors = [Vector2(0, 1)]
export var output_vectors = [Vector2(0, -1)]

onready var input_arrow_tex = preload("res://World/Tower/Pieces/input_arrow.png")
onready var output_arrow_tex = preload("res://World/Tower/Pieces/output_arrow.png")

onready var item_list = get_node("/root/GlobalItemList")

#var move_to = []
var take_from = []

#var move_to_last_index = 0
var take_from_last_index = 0

onready var tween = $Tween
onready var arrows = $Arrows

func _ready():
	if get_parent().is_in_group("tower"):
		_update_connections()
	._ready()
	
	_duplicate_vectors()
	_make_input_output_arrows()

func _duplicate_vectors():# this prevents rotation from affecting all other pieces with same vectors
	input_vectors = input_vectors.duplicate(true)
	output_vectors = output_vectors.duplicate(true)

func rotate_piece():
	.rotate_piece()
	for i in input_vectors.size():
		input_vectors[i] = input_vectors[i].rotated(PI*0.5)
	for i in output_vectors.size():
		output_vectors[i] = output_vectors[i].rotated(PI*0.5)
	_make_input_output_arrows()
	
func rotate_to(r):
	.rotate_to(r)
	for i in input_vectors.size():
		input_vectors[i] = input_vectors[i].rotated(r)
	for i in output_vectors.size():
		output_vectors[i] = output_vectors[i].rotated(r)
	_make_input_output_arrows()
	

func _update_connections():
	var tower = get_parent()
	take_from = []
	take_from_last_index = 0
	for i in input_vectors.size():
		var input_neighbour = tower.get_piece_at_location(position + input_vectors[i] * 16)
		if input_neighbour != null && input_neighbour.is_in_group("input_output") && input_neighbour.moves_output_to(input_vectors[i]*-1):
			take_from.append(input_neighbour)
	
#	for i in output_vectors.size():
#		var output_neighbour = tower.get_piece_at_location(position + output_vectors[i] * 16)
#		if output_neighbour != null && output_neighbour.is_in_group("input_output") && output_neighbour.gets_input_from(output_vectors[i]*-1):
#			move_to.append(output_neighbour)

func set_storage(s):
	storage = s

func has_item():
	return storage != null

func _have_in_storage(code):
	return storage.item_code == code

func pop_item():
	var i = storage
	storage = null
	return i

func place():
	.place()
	hide_input_output()
	_update_connections()

func moves_output_to(vector):
	for i in output_vectors:
		if _round_vec(i) == _round_vec(vector):
			return true

	return false

func _round_vec(vec): #floating point errors, there is no int vector2 in godot
	var new = Vector2()
	new.x = round(vec.x)
	new.y = round(vec.y)
	return new

#func gets_input_from(vector):
#	for i in input_vectors:
#		prints(vector,i)
#		if i == vector:
#			return true
#
#	return false
#
func _take_from_input():
	var took_item = false
	for i in range(take_from_last_index, take_from.size()):
		if take_from[i] != null:
			if storage == null && !took_item && take_from[i].has_item():
				var item = take_from[i].pop_item()
				took_item = true
				call_deferred("set_storage", item) # call 1 frame later so item doesnt get transported instantly across all transporters
				_animate_item_movement(item)

	# if previous take from didnt have storage, check for all
	if storage == null:
		for i in take_from.size():
			if take_from[i] != null:
				if storage == null && !took_item && take_from[i].has_item():
					#storage = take_from[i].pop_item()
					var item = take_from[i].pop_item()
					took_item = true
					call_deferred("set_storage", item) # call 1 frame later so item doesnt get transported instantly across all transporters
					_animate_item_movement(item)
					take_from_last_index = i
	
	take_from_last_index += 1
	if take_from_last_index >= take_from.size():
		take_from_last_index = 0

func _animate_item_movement(item):
	#tween.interpolate_callback(self, 0.1,, item)
	tween.interpolate_property(item, "position", item.position, position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _make_input_output_arrows():
	for c in arrows.get_children():
		c.queue_free()
	
	for i in input_vectors:
		var spr = Sprite.new()
		spr.texture = input_arrow_tex
		spr.centered = false
		spr.rotation = -i.angle_to(Vector2(0, -1))+PI
		wrap_rotation(spr)
		#_translate_sprite_from_degrees(spr)
		_fix_in_arrow_position(spr)
		spr.position += i * 16
		spr.z_index = 1000
		arrows.add_child(spr)
	for i in output_vectors:
		var spr = Sprite.new()
		spr.texture = output_arrow_tex
		spr.centered = false
		spr.rotation = -i.angle_to(Vector2(0, -1))
		wrap_rotation(spr)
		#_translate_sprite_from_degrees(spr)
		_fix_out_arrow_position(spr)
		spr.position += i * 16
		spr.z_index = 1000
		arrows.add_child(spr)


# not really sure why these positions get so messed up by rotation, but this fixes it kinda (but is super ugly)
func _fix_in_arrow_position(arrow_spr):
	var rot = floor(arrow_spr.rotation_degrees)
	if rot == 90:
		arrow_spr.position = Vector2(16, 0)
	if rot == 180:
		arrow_spr.position = Vector2(16, 16)
	if rot == 270:
		arrow_spr.position = Vector2(0, 16)

func _fix_out_arrow_position(arrow_spr):
	var rot = floor(arrow_spr.rotation_degrees)
	if rot == -180:
		arrow_spr.position = Vector2(16, 16)
	if rot == -90:
		arrow_spr.position = Vector2(0, 16)
	if rot == 90:
		arrow_spr.position = Vector2(16, 0)
	

func display_input_output():
	arrows.visible = true

func hide_input_output():
	arrows.visible = false

func _mouse_enter():
	display_input_output()

func _mouse_exit():
	if state == states.PLACED:
		hide_input_output()

func hover():
	display_input_output()
	.hover()

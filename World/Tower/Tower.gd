extends Node2D

var time = 0.0
export (float) var step_interval = 0.500# 60 / song_bmp. (in this case 121)
var step_index = 0
var audio_player
var prev_audio_time = 0.0

func _ready():
	audio_player = get_tree().root.get_node("Game/Music")

func _physics_process(delta):
	var new_time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	var audio_delta = new_time - prev_audio_time
	prev_audio_time = new_time
	
	if abs(audio_delta) > 3.0:
		audio_delta = 0.0
	
	time += audio_delta
	if time > step_interval:
		time -= step_interval
		for c in get_children():
			if c.is_in_group("machine_piece"):
				c._next_produce_step(step_index)

		step_index += 1
		if step_index >= 8:
			step_index = 0

#func _physics_process(delta):
#	time += delta
#
#	if time > step_interval:
#		time -= step_interval
#		for c in get_children():
#			if c.is_in_group("machine_piece"):
#				c._next_produce_step(step_index)
#
#		step_index += 1
#		if step_index >= 8:
#			step_index = 0

func update_surrounding_pieces(pos):
	var left = get_piece_at_location(pos + Vector2(-1,0)*16)
	var right = get_piece_at_location(pos + Vector2(1,0)*16)
	var up = get_piece_at_location(pos + Vector2(0,-1)*16)
	var down = get_piece_at_location(pos + Vector2(0,1)*16)
	
	if left:
		left._update_connections()
	if right:
		right._update_connections()
	if up:
		up._update_connections()
	if down:
		down._update_connections()

func get_piece_at_location(pos):
	pos = _round_pos(pos)
	for i in get_children():
		if i.is_in_group("machine_piece") && !i.is_in_group("heatsink"):
			for x in range(0, i.size.x):
				for y in range(0, i.size.y):
					if _round_pos(i.position + Vector2(x,y)*16) == pos:
						return i

func _round_pos(pos): #floating point errors, there is no int vector2 in godot
	var new = Vector2()
	new.x = round(pos.x)
	new.y = round(pos.y)
	return new

func is_next_to_piece(pos):
	pos = _round_pos(pos)
	for i in get_children():
		if i.is_in_group("machine_piece") && !i.is_in_group("heatsink"):
			# this could also go in loop, but i like this
			if get_piece_at_location(pos + Vector2(-1,0)*16) != null:
				return true
			if get_piece_at_location(pos + Vector2(1,0)*16) != null:
				return true
			if get_piece_at_location(pos + Vector2(0,-1)*16) != null:
				return true
			if get_piece_at_location(pos + Vector2(0,1)*16) != null:
				return true
	return false

func destroy_piece_at(pos):
	var piece = get_piece_at_location(pos)
	if piece != null:
		if !piece.is_in_group("source"):
			
			piece.destroy_storage()
			piece.queue_free()
			
	update_surrounding_pieces(pos)

func set_export_phase(p):
	$TowerSource.set_export_phase(p)

func reset():
	for piece in get_children():
		if piece.is_in_group("machine_piece") && !piece.is_in_group("heatsink") && !piece.is_in_group("source"):
			
			piece.destroy_storage()
			piece.queue_free()

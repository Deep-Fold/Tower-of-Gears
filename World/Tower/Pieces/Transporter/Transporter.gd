extends "res://World/Tower/Pieces/InputOutputPiece.gd"

func _produce_step():
	_take_from_input()
	if rand_range(0.0, 1.0) > 0.9:
		_add_small_smoke()
	_release_embers(0.05)
	tween.interpolate_property($Gear, "rotation_degrees", 0, -90, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property($GearSmall, "rotation_degrees", 0, 90, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _mouse_enter():
	display_input_output()

func _mouse_exit():
	if state == states.PLACED:
		hide_input_output()

#
#func _move_storage_to():
#	if storage != null:
#		for i in range(move_to_last_index, move_to.size()):
#			if move_to[i].storage == null:
#				move_to[i].set_storage(storage)
#				storage = null
#
#	# previous move to's didnt have free space, check for all
#	if storage != null:
#		for i in move_to.size():
#			if move_to[i].storage == null:
#				move_to[i].set_storage(storage)
#				move_to_last_index = i
#				storage = null
#
#	move_to_last_index += 1
#	if move_to_last_index > move_to.size():
#		move_to_last_index = 0

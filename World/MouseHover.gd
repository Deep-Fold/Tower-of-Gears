extends Position2D

signal attempt_piece_place

var holding_piece = null
var previous_rotation = 0

func _physics_process(_delta):
	if holding_piece != null:
		#position = (get_global_mouse_position()-Vector2(8,16)).snapped(Vector2(16, 16))+Vector2(0,8)
		position = (get_global_mouse_position()-Vector2(8,8)).snapped(Vector2(16,16))
		if Input.is_action_just_released("place_piece"):
			emit_signal("attempt_piece_place", holding_piece, position)
		if Input.is_action_just_released("disable_place_piece"):
			holding_piece = null
			get_children()[0].queue_free()
		
func _input(event):
	if holding_piece != null && event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				holding_piece.rotate_piece()
				previous_rotation = holding_piece.get_piece_rotation()
			elif event.button_index == BUTTON_WHEEL_DOWN:
				holding_piece.rotate_piece()
				previous_rotation = holding_piece.get_piece_rotation()
			
			if previous_rotation > 360:
				previous_rotation  = 90

func set_default_piece_rotation():
	pass
	#if holding_piece != null:
	#	holding_piece.rotate_to(deg2rad(previous_rotation))

extends Node2D

signal sky_height

onready var piece_data = get_node("/root/PieceData").piece_data
onready var inventory = get_node("/root/MainInventory")
onready var mouse_hover = $MouseHover
onready var tower = $Tower
onready var camera = $CameraPosition

func _ready():
	emit_signal("sky_height", camera.position.y)
	

func _on_GUI_piece_build_selected(piece_code):
	if mouse_hover.get_children().size() == 0 && _can_afford_piece(piece_code):
		var piece = piece_data[piece_code].scene.instance()
		piece.code = piece_code
		mouse_hover.add_child(piece)
		piece.hover()
		mouse_hover.holding_piece = piece

func _on_MouseHover_attempt_piece_place(piece, pos):	
	if _can_afford_piece(piece.code):
		if is_next_to_piece(piece, pos-tower.position) && _tower_has_place_free(piece, pos-tower.position):
			mouse_hover.remove_child(piece)
			tower.add_child(piece)
			piece.global_position = pos
			#mouse_hover.holding_piece = null
			_subtract_piece_cost(piece)
			piece.place()
			tower.update_surrounding_pieces(pos-tower.position)
			# give a new instance of piece, so multiple can be placed without re-opening menu
			
			var new_piece = piece_data[piece.code].scene.instance()
			mouse_hover.holding_piece = new_piece
			new_piece.code = piece.code
			new_piece.modulate = Color(1,1,1,0.5)
			mouse_hover.add_child(new_piece)
			mouse_hover.set_default_piece_rotation()

func is_next_to_piece(piece, pos):
	for x in piece.size.x:
		for y in piece.size.y:
			var other = tower.is_next_to_piece(pos + Vector2(x,y)*16)
			if other != false:
				return true
	return false

func _tower_has_place_free(piece, pos):
	for x in piece.size.x:
		for y in piece.size.y:
			var other = tower.get_piece_at_location(pos + Vector2(x,y)*16)
			if other != null:
				return false
	return true

func _subtract_piece_cost(piece):
	var all_costs = piece_data[piece.code].cost
	
	for c in all_costs.keys():
		var cost = piece_data[piece.code].cost[c]
		inventory.remove_item(c, cost)

func _can_afford_piece(piece_code):
	var all_costs = piece_data[piece_code].cost
	
	for c in all_costs.keys():
		var cost = piece_data[piece_code].cost[c]
		var have = inventory.get_item_amount(c)
		if have < cost:
			return false
	return true

func move_camera(amount):
	if mouse_hover.holding_piece == null:
		camera.move(amount)
		emit_signal("sky_height", camera.position.y)

func set_export_phase(p):
	tower.set_export_phase(p)

func _on_GUI_attempt_destroy(pos):
	tower.destroy_piece_at(pos-tower.position+Vector2(0, 32)+camera.position-Vector2(136,192))

func reset():
	$Tower.reset()

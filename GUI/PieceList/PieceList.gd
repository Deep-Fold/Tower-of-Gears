extends Control

onready var main_inventory = get_node("/root/MainInventory")
onready var piece_data = get_node("/root/PieceData").piece_data
onready var item_data = get_node("/root/GlobalItemList").item_data
onready var piece_scene = preload("res://GUI/PieceList/PieceListItem.tscn")
onready var tooltip_component = preload("res://GUI/Inventory/ToolTipComponent.tscn")

onready var piece_list = $ColorRect/ScrollContainer/VBoxContainer
onready var tooltip = $ToolTip/VBoxContainer

enum states {VISIBLE, HIDDEN}
var state = states.HIDDEN

signal piece_selected

func _ready():
	main_inventory.connect("update_inventory", self, "_on_inventory_update_inventory")

func _build_piece_view():
	
	var children = piece_list.get_children()
	for i in children.size():
		var c = children[i]
		c.queue_free()

	for i in piece_data.keys():
		if piece_data[i].unlocked:
			var p = piece_scene.instance()
			piece_list.add_child(p)
			var machine_piece_scene = piece_data[i].scene.instance()
			
			p.set_amount_possible(_amount_possible_for_piece(piece_data[i]))
			p.set_image(machine_piece_scene.get_node("Sprite").texture)
			p.set_name(String(piece_data[i].name))
			p.connect("piece_selected", self, "_on_piece_item_selected")
			p.connect("hover", self, "_on_Piece_Button_hover")
			p.piece_type = i
			
			machine_piece_scene.queue_free()

func _on_piece_item_selected(i):
	$ToolTip.visible = false
	emit_signal("piece_selected", i)

func _amount_possible_for_piece(p):
	var cost = p.cost.keys()
	var minimum = 999
	if cost.size() > 0:
		for c in cost:
			var amount = floor(main_inventory.get_item_amount(c)/p.cost[c]) # amount in inventory / amount required
			minimum = min(amount, minimum)

	return minimum

func _on_inventory_update_inventory():
	if state == states.VISIBLE:
		_build_piece_view()

func _on_Toggle_pressed():
	if state == states.HIDDEN:
		_build_piece_view()
		state = states.VISIBLE
		$AnimationPlayer.play("expand")
	else:
		state = states.HIDDEN
		$AnimationPlayer.play("expand", -1, -1, true)

func _on_Piece_Button_hover(hover_over, piece_code):
	$ToolTip.visible = hover_over
	$ToolTip.rect_size.y = 0
	tooltip.rect_size.y = 0
	for c in tooltip.get_children():
		if !c.is_in_group("header"):
			c.queue_free()

	if hover_over:
		var items_required = piece_data[piece_code].cost
		var keys = items_required.keys()
		$ToolTip.get_node("Description").text = piece_data[piece_code].description + "\n\ncost:"
		for k in keys:
			var ttc = tooltip_component.instance()
			#$ToolTip.rect_size.y += 16
		
			ttc.get_node("HBoxContainer/TextureRect").texture = item_data[k].texture
			ttc.get_node("HBoxContainer/Item").text = item_data[k].name
			ttc.get_node("HBoxContainer/Amount").text = "x " + String(items_required[k])
			
			#var text_height = $ToolTip.get_node("Description").rect_size.y
			#$ToolTip.get_node("ColorRect").rect_size.y = text_height
			#tooltip.rect_position.y = text_height
			
			tooltip.add_child(ttc)

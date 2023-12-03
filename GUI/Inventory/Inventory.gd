extends Control

signal early_export

onready var main_inventory = get_node("/root/MainInventory")
onready var item_list = get_node("/root/GlobalItemList")
onready var export_requirements = get_node("/root/ExportRequirements")
onready var inventory_node = preload("res://GUI/Inventory/InventoryItem.tscn")
onready var export_node = preload("res://GUI/Inventory/ExportItem.tscn")

onready var inventory_list = $HBoxContainer/ColorRect/ScrollContainer/InventoryList
onready var export_list = $HBoxContainer/ColorRect2/ScrollContainer/ExportList

enum states {VISIBLE, HIDDEN}
var state = states.HIDDEN

func _ready():
	export_requirements.connect("time_changed", self, "_on_export_time_changed")
	export_requirements.connect("export_changed", self, "_on_export_update_export")
	main_inventory.connect("update_inventory", self, "_on_inventory_update_inventory")
	_build_export_view()

func _build_inventory_view():
	for c in inventory_list.get_children():
		if !c.is_in_group("header"):
			c.queue_free()

	var inventory = main_inventory.get_item_list()
	for i in inventory:
		var n = inventory_node.instance()
		n.get_node("HBoxContainer/Amount").text = "x "+String(i.amount)
		n.get_node("HBoxContainer/Name").text = item_list.item_data[i.code].name
		n.get_node("HBoxContainer/TextureRect").texture = item_list.item_data[i.code].texture
		inventory_list.add_child(n)

func _build_export_view():
	for c in export_list.get_children():
		if !c.is_in_group("header"):
			c.queue_free()

	var requirements = export_requirements.get_current_requirement()
	export_list.get_node("EarlyExport").disabled = !export_requirements.requirements_met()
	for i in requirements.keys():
		var item_data = item_list.item_data[i]
		#var have = main_inventory.get_item_amount(i)
		var r = requirements[i]
		var n = export_node.instance()
		#n.get_node("HBoxContainer/Amount").text = String(have) + "/" + String(r)
		n.get_node("HBoxContainer/Amount").text = "x "+String(r)
		n.get_node("HBoxContainer/Name").text = item_data.name
		n.get_node("HBoxContainer/TextureRect").texture = item_data.texture
		export_list.add_child(n)

func _on_export_update_export():
	_build_export_view()

func _on_export_time_changed(time):
	export_list.get_node("TimeLeft").text = String(time) + " seconds left"

func _on_inventory_update_inventory():
	if state == states.VISIBLE:
		_build_export_view()
		_build_inventory_view()

func _on_Toggle_pressed():
	if state == states.HIDDEN:
		_build_inventory_view()
		_build_export_view()
		state = states.VISIBLE
		$AnimationPlayer.play("expand")
	else:
		state = states.HIDDEN
		$AnimationPlayer.play("expand", -1, -1, true)


func _on_EarlyExport_pressed():
	emit_signal("early_export")

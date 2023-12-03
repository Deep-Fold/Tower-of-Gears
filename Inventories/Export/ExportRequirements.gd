extends Node

signal do_export
signal export_changed
signal time_changed

onready var item_list = get_node("/root/GlobalItemList")
onready var global_inventory = get_node("/root/MainInventory")

var previous_time_seconds = 0
var seconds_in_day = 60
var seconds_to_export = 0
var requirement_index = 0

var time_enabled = true
var requirements = []

func _ready():
	requirements = [
		{
			"time_to_complete": 200,# seconds
			"required": {
				item_list.items.STONE: 10,
				item_list.items.BRICK: 5
			}
		},
		{
			"time_to_complete": 300,# seconds
			"required": {
				item_list.items.STONE: 50,
				item_list.items.BRICK: 20,
				item_list.items.MELTED_IRON: 20,
				item_list.items.IRON_SHEET: 10,
				item_list.items.HEATSINK: 5,
			}
		},
		{
			"time_to_complete": 400,# seconds
			"required": {
				item_list.items.BRICK: 20,
				item_list.items.MELTED_IRON: 20,
				item_list.items.IRON_SHEET: 30,
				item_list.items.CRUDE_OIL: 30,
				item_list.items.REFINED_OIL: 20,
				item_list.items.CARBON: 10,
				item_list.items.STEEL_SHEET: 1,
				item_list.items.HEATSINK: 15,
			}
		},
		{
			"time_to_complete": 350,# seconds
			"required": {
				item_list.items.IRON_SHEET: 20,
				item_list.items.CARBON: 15,
				item_list.items.REFINED_OIL: 20,
				item_list.items.STEEL_SHEET: 15,
				item_list.items.MELTED_GOLD: 20,
				item_list.items.GOLD_WIRE: 10,
				item_list.items.HEATSINK: 75,
			}
		},
		{
			"time_to_complete": 200,# seconds
			"required": {
				item_list.items.ANTIMATTER: 1,
			}
		},
	]
	seconds_to_export = requirements[requirement_index].time_to_complete
	emit_signal("export_changed")

func reset():
	requirement_index = 0
	seconds_to_export = requirements[requirement_index].time_to_complete

func requirements_met():
	var r = get_current_requirement()
	for k in r.keys():
		var need = r[k]
		var have = global_inventory.get_item_amount(k)

		if have < need:
			return false
	return true



#func _early_export():
#	if requirements_met():
#		emit_signal("do_export")

func get_current_requirement():
	if requirement_index < requirements.size():
		return requirements[requirement_index].required
	return {}

func _physics_process(delta):
	if time_enabled:
		seconds_to_export -= delta
		
		if floor(seconds_to_export) != previous_time_seconds:
			previous_time_seconds = floor(seconds_to_export)
			emit_signal("time_changed", previous_time_seconds)
		
		if seconds_to_export <= 0:
			emit_signal("do_export")

func set_time_enabled(e):
	time_enabled = e

func _export():
	requirement_index +=1
	if requirement_index < requirements.size():
		seconds_to_export = requirements[requirement_index].time_to_complete
		emit_signal("export_changed")

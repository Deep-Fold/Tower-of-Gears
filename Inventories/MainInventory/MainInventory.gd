extends Node

signal update_inventory

var inventory = {}

func reset():
	inventory = {}
	add_item(0, 50) # add starting stone

func _ready():
	add_item(0, 50) # add starting stone

func add_item(item_code, amount = 1):
	if inventory.has(item_code):
		inventory[item_code] += amount
	else:
		inventory[item_code] = amount
	emit_signal("update_inventory")
		
func remove_item(item_code, amount = 1):
	if inventory.has(item_code):
		inventory[item_code] -= amount
	emit_signal("update_inventory")

func get_item_amount(item_code):
	if inventory.has(item_code):
		return inventory[item_code]
	return 0

func get_item_list():
	var keys = inventory.keys()
	var list = []
	for k in keys:
		var item = {
			"code": k,
			"amount": inventory[k]
		}
		list.append(item)
	return list

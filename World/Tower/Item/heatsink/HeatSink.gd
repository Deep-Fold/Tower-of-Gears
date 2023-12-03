extends "res://World/Tower/Item/Item.gd"

var heat_capacity = 0.0

var taking_heat_from = []
var size = Vector2(1,1)

func _next_produce_step(_index):
	if heat_capacity < 1.0:
		for i in taking_heat_from:
			if i.heat > 0.1:
				i.remove_heat(0.1)
				heat_capacity += 0.05
			else:
				heat_capacity += i.heat
				i.heat = 0.0
	
	$Glow.modulate.a = 1.0 - heat_capacity

func free_fall():
	.free_fall()
	$Glow.visible = false

func _on_PieceDetector_area_entered(area):
	if state == states.IN_MACHINE:
		var p = area.get_parent()
		
		if p.is_in_group("machine_piece") && !p.is_in_group("heatsink"):
			taking_heat_from.append(p)

func _on_PieceDetector_area_exited(area):
	if state == states.IN_MACHINE:
		var p = area.get_parent()
		
		if p.is_in_group("machine_piece") && !p.is_in_group("heatsink"):
			taking_heat_from.erase(p)

func _update_connections():
	pass

func destroy_storage():
	pass

extends "res://World/Tower/Pieces/MachinePiece.gd"

#signal produced
onready var tween = $Tween

onready var items = get_node("/root/GlobalItemList").items
onready var item_scene = preload("res://World/Tower/Item/Item.tscn")

var unlocked = {
}

func _ready():
	storage = []
	unlocked = {
		items.STONE: true,
		items.IRON_ORE: false,
		items.CRUDE_OIL: false,
		items.GOLD_ORE: false,
	}

func set_export_phase(p):
	match p:
		1:
			unlocked[items.IRON_ORE] = true
		2:
			unlocked[items.CRUDE_OIL] = true
		3:
			unlocked[items.GOLD_ORE] = true
		

func _produce_step():
	tween.interpolate_property($Sprite.material, "shader_param/offset", 0.7, 0.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property($Sprite.material, "shader_param/color", 0.0, 0.7, 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.2)
	tween.start()
	$Audio.play()
	
	for k in unlocked.keys():
		if unlocked[k]:
			_produce_item(k)

func _produce_item(code):
	if !_have_in_storage(code):
		var item = item_scene.instance()
		item.set_item_code(code)
		get_parent().add_child(item)
		item.global_position = global_position
		storage.append(item)
	heat = 0

func _update_connections():
	pass

func _get_by_code(code):
	for s in storage:
		if s.item_code == code:
			var item = s
			storage.erase(item)
			return item

func _have_in_storage(code):
	for s in storage:
		if s.item_code == code:
			return true
	return false

func pop_item():
	var item = storage[randi() % storage.size()]
	storage.erase(item)
	return item

func has_item():
	return storage.size()>0

func moves_output_to(_vector):
	return true # source sends input to everywhere

func gets_input_from(_vector):
	return false

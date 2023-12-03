extends Node

signal show_lines

onready var export_requirements = get_node("/root/ExportRequirements")
onready var inventory = get_node("/root/MainInventory")
onready var piece_data = get_node("/root/PieceData")
onready var gui = $GUI/GUI

enum states {TITLE, PLAYING, WIN, GAME_OVER}
var state = states.PLAYING

var lines = [
	["Welcome to the Tower of Gears.", "This wondrous machine was recently found on a patch of earth, rich in resources.", "It produces all kinds of items, by installing machines you can process these items.", "For now the tower only produces stone.", "I recommend installing some Transporters and an Ejector first.", "Or you will run out of resources very quick.", "place them onto the starting machine and watch them work!", "Arrows pointing into the machine indicate input.", "arrows pointing away from the machine indicate output."],
	["Every so often you have to export some items.", "Check you inventory to see how long you have and what items you need.", "Failure to export in time means the tower will be shut down."],
	["You completed the first export! The tower now produces iron ore.", "You might have noticed a red glow.", "It means your machines are overheating and will stop functioning.", "Create heatsinks to cool down your machines.", "Machines also cool down slowly over time.", "The higher up they are, the faster your machines cool down."],
	["You completed the second export! The tower now produces crude oil."],
	["You completed the third export! The tower now produces gold ore."],
	["You completed the fourth export! Now produce some antimatter and win the game!"],
]
func _ready():
	$Music.play()
	emit_signal("show_lines", lines[0])
	export_requirements.connect("do_export", self, "_on_force_do_export")

func _on_force_do_export():
	if state == states.PLAYING:
		if export_requirements.requirements_met():
			_export()
		else:
			_game_over()

func _on_GUI_early_export():
	if export_requirements.requirements_met():
		_export()

func _export():
	var requirement = export_requirements.get_current_requirement()
	for k in requirement.keys():
		var need = requirement[k]
		inventory.remove_item(k, need)
	
	export_requirements._export()
	piece_data.unlock_for_export_phase(export_requirements.requirement_index)
	
	match export_requirements.requirement_index:
		1:
			emit_signal("show_lines", lines[2])
		2:
			emit_signal("show_lines", lines[3])
		3:
			emit_signal("show_lines", lines[4])
		4:
			emit_signal("show_lines", lines[5])
	
	$World.set_export_phase(export_requirements.requirement_index)
	
	if export_requirements.requirement_index == export_requirements.requirements.size():
		_win()

func _game_over():
	state = states.GAME_OVER
	gui.play_lose()
	emit_signal("show_lines", ["You failed to export the items in time."])

func _win():
	state = states.WIN
	gui.play_win()
	emit_signal("show_lines", ["You exported all items, good job!"])

func _on_ExportMessage_timeout():
	if !gui._is_showing_line():
		emit_signal("show_lines", lines[1])
		$ExportMessage.stop()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if !gui.piece_list_visible():
				if event.button_index == BUTTON_WHEEL_UP:
					$World.move_camera(-16)
				elif event.button_index == BUTTON_WHEEL_DOWN:
					$World.move_camera(16)


func _on_GUI_restart():
	$World.reset()
	inventory.reset()
	export_requirements.reset()


func _on_GUI_change_time_enabled(e):
	export_requirements.set_time_enabled(e)

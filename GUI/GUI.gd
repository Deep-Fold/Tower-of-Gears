extends Control

signal piece_build_selected
signal early_export
signal attempt_destroy
signal restart
signal change_time_enabled

func _ready():
	$PieceList.connect("piece_selected", self, "_on_piece_selected")

func _on_piece_selected(p):
	$PieceList._on_Toggle_pressed()
	emit_signal("piece_build_selected", p)

func _on_Inventory_early_export():
	emit_signal("early_export")

func play_win():
	$EndScreen.play_win()
	$PieceList.visible = false
	$Inventory.visible = false
	$Destroy.visible = false

func play_lose():
	$PieceList.visible = false
	$Inventory.visible = false
	$Destroy.visible = false
	$EndScreen.play_lose()

func _on_Destroy_attempt_destroy(pos):
	emit_signal("attempt_destroy", pos)

func _is_showing_line():
	return $InfoPopup.is_showing_line()

func _on_Game_show_lines(lines):
	$InfoPopup._do_popup_line(lines)

func piece_list_visible():
	return $PieceList.state == $PieceList.states.VISIBLE

func _on_EndScreen_restart():
	$PieceList.visible = true
	$Inventory.visible = true
	$Destroy.visible = true
	emit_signal("restart")

func _on_SoundControl_change_time_enabled(e):
	emit_signal("change_time_enabled", e)

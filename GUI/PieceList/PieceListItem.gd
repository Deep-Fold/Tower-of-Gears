extends Control

signal hover
signal piece_selected

var amount_possible = 0
onready var name_text = $Button/Name
onready var amount_text = $Button/AmountPossible
onready var image = $Button/Image

var piece_type = null

func set_name(n):
	name_text.text = n

func set_amount_possible(a):
	if a > 0:
		$Button.disabled = false
	else:
		$Button.disabled = true
	amount_text.text = "x " + String(a)

func set_image(tex):
	image.texture = tex

func _on_Button_button_down(): # button down, because if inventory refreshes often, it is difficult to press & release button before it gets updated
	emit_signal("piece_selected", piece_type)

func _on_Button_mouse_entered():
	emit_signal("hover", true, piece_type)

func _on_Button_mouse_exited():
	emit_signal("hover", false, piece_type)

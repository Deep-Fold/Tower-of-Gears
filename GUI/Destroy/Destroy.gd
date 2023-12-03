extends Control

signal attempt_destroy
var destroy_active = false

onready var tex = $DestroyTexture

func _input(event):
	if destroy_active:
		if event is InputEventMouseButton && event.is_pressed():
			if event.button_index == 2:# right mouse
				destroy_active = false
				tex.visible = false
			if event.button_index == 1:# left mouse
				emit_signal("attempt_destroy", tex.rect_position)

func _physics_process(_delta):
	if destroy_active:
		tex.rect_position = (get_global_mouse_position()-Vector2(8,8)).snapped(Vector2(16,16))

func _on_Button_button_down():
	destroy_active =! destroy_active
	tex.visible = destroy_active

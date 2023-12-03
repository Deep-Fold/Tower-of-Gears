extends Control

onready var c_rect = $ColorRect
onready var description = $Description
onready var container = $VBoxContainer

func _physics_process(_delta):
	if visible:
		c_rect.rect_size.y = description.rect_size.y + container.rect_size.y
		container.rect_position.y = description.rect_size.y
		rect_position = get_global_mouse_position()-Vector2(113,0)
		rect_position.y = max(0, rect_position.y)
		rect_position.y = min(320-c_rect.rect_size.y, rect_position.y)#320 is screen height

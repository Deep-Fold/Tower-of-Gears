extends Node2D

export var size = Vector2(1,1)
export (bool) var sprite_rotate = true

onready var smoke_small = preload("res://World/Tower/SmokeParticle/SmokeSmall.tscn")
onready var smoke_big = preload("res://World/Tower/SmokeParticle/SmokeBig.tscn")

export (Array) var produce_steps = [true, true, true, true, true, true, true, true]

enum states {PLACED, HOVER}
var state = states.PLACED
onready var sprite = $Sprite

var heat = 0.0
export (float) var heat_increase = 0.01
var storage = null

var piece_rotation = 0
var code = null
var cooling_down = false

func _ready():
	pass
#	$Area2D/CollisionShape2D.shape.extents = size * 8
#	$Area2D/CollisionShape2D.position = size*8*0.5

func destroy_storage():
	if storage != null:
		storage.queue_free()

func _next_produce_step(index):
	if cooling_down:
		heat -= 0.05
		if heat <= 0.0:
			cooling_down = false
	else:
		if heat < 1.0:
			heat += heat_increase - (heat_increase * (position.y / -500))# 1000 is max camera position
			$HeatGlow.modulate.a = heat*0.4
			
			if produce_steps[index]:
				_produce_step()
		else:
			_add_small_smoke()
			cooling_down = true
	if heat <= 0.0:
		heat = 0.0

func remove_heat(amount):
	heat -= amount

func _produce_step():
	pass

func rotate_piece():
	piece_rotation += 90
	if sprite_rotate:
		var mat = $Embers.process_material.duplicate()
		var vec2 = Vector2(mat.direction.x, mat.direction.y).rotated(PI*0.5)
		mat.direction.x = vec2.x
		mat.direction.y = vec2.y
		$Embers.process_material = mat
		sprite.rotation_degrees += 90
		wrap_rotation(sprite)
		_translate_sprite_from_degrees(sprite)

func rotate_to(r):
	if sprite_rotate:
		piece_rotation = round(rad2deg(r))
		var mat = $Embers.process_material.duplicate()
		var vec2 = Vector2(mat.direction.x, mat.direction.y).rotated(r)
		mat.direction.x = vec2.x
		mat.direction.y = vec2.y
		$Embers.process_material = mat
		sprite.rotation = r
		wrap_rotation(sprite)
		_translate_sprite_from_degrees(sprite)

func get_piece_rotation():
	return piece_rotation

func wrap_rotation(spr):
	spr.rotation_degrees = floor(spr.rotation_degrees)
	if spr.rotation_degrees >= 360:
		spr.rotation_degrees = 0

# stupid, but because sprites are not centered, have to offset them to keep in same position
func _translate_sprite_from_degrees(spr):
	if round(spr.rotation_degrees) == 0:
		spr.position = Vector2(0, 0)
	elif round(spr.rotation_degrees) == 90:
		spr.position = Vector2(16, 0)
	elif round(spr.rotation_degrees) == 180:
		spr.position = Vector2(16, 16)
	elif round(spr.rotation_degrees) == 270:
		spr.position = Vector2(0,16)

func hover():
	state = states.HOVER
	modulate = Color(1,1,1,0.5)

func place():
	state = states.PLACED
	modulate = Color(1,1,1,1)

func _on_Area2D_mouse_entered():
	_mouse_enter()

func _mouse_enter():
	pass

func _on_Area2D_mouse_exited():
	_mouse_exit()

func _mouse_exit():
	pass

func _update_connections():
	pass

func _add_small_smoke(vel = Vector2()):
	var s = smoke_small.instance()
	s.position = position + Vector2(8,8)
	s.velocity += vel
	get_parent().add_child(s)

func _add_big_smoke(vel = Vector2()):
	var s = smoke_big.instance()
	s.position = position + Vector2(8,8)
	s.velocity += vel
	get_parent().add_child(s)

func _release_embers(time = 0.1):
	$Embers.emitting = true
	$StopEmberTimer.wait_time = time
	$StopEmberTimer.start()


func _on_StopEmberTimer_timeout():
	$Embers.emitting = false

extends "res://World/Tower/Pieces/InputOutputPiece.gd"

func _next_produce_step(index):
	._next_produce_step(index)
	_take_from_input()

func _produce_step():
	if storage != null:
		_eject_item(storage)
		storage = null

func _eject_item(item):
	$AnimationPlayer.play("eject")
	tween.interpolate_callback(self, 0.5, "_play_reset")
	tween.start()
	item.free_fall()
	item.velocity = (output_vectors[0]*rand_range(200, 300)).rotated(rand_range(-0.4, 0.4))
	
	_add_big_smoke(Vector2(0, rand_range(-15,-20)))
	_release_embers(0.4)
	$Audio.play()

func rotate_to(r):
	.rotate_to(r)
	$GlowSprite.rotation = r
	$EjectorCover.rotation = r
	_translate_sprite_from_degrees($GlowSprite)
	_translate_sprite_from_degrees($EjectorCover)

func rotate_piece():
	.rotate_piece()
	
	$GlowSprite.rotation_degrees += 90
	$EjectorCover.rotation_degrees += 90
	wrap_rotation($GlowSprite)
	wrap_rotation($EjectorCover)
	_translate_sprite_from_degrees($GlowSprite)
	_translate_sprite_from_degrees($EjectorCover)

func _play_reset():
	$AnimationPlayer.play("reset")

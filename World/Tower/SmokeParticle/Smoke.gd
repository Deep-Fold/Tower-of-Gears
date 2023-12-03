extends Node2D

var velocity = Vector2()

func _ready():
	var t = rand_range(5.0, 10.0)
	$Timer.wait_time = t
	$Timer.start()
	$Particles2D.emitting = true
	$Particles2D.lifetime = t
	
	velocity += Vector2(rand_range(2, 5), rand_range(-5,-10))

func _physics_process(delta):
	velocity.y -= 5.0*delta# gravity
	position += velocity * delta


func _on_Timer_timeout():
	queue_free()

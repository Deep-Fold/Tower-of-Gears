extends CanvasLayer

export (Gradient) var sky_gradient
export (float) var gradient_max = -500.0

# add selective transporters

var material

func _ready():
	material = $ColorRect.material

func set_sky_height(height):
	material.set_shader_param("color1", sky_gradient.interpolate((height)/gradient_max))
	material.set_shader_param("color2", sky_gradient.interpolate((height-300)/gradient_max))
	#$ColorRect.color = sky_gradient.interpolate(height/gradient_max)

func _on_World_sky_height(h):
	set_sky_height(h)

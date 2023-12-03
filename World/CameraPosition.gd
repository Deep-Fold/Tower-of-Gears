extends Position2D

func move(amount):
	position.y += amount
	position.y = max(-500, position.y)
	position.y = min(192, position.y)

extends Node2D

var item_code = null
onready var item_list = get_node("/root/GlobalItemList")
onready var inventory = get_node("/root/MainInventory")

onready var tween = $Tween
var velocity = Vector2()
enum states {IN_MACHINE, FREE_FALL, LANDED}
var state = states.IN_MACHINE
var rotation_speed = 0.0

func _ready():
	if item_code != null:
		$Sprite.texture = item_list.item_data[item_code].texture

func free_fall():
	state = states.FREE_FALL
	rotation_speed = rand_range(-3, 3)
	z_index = 1

func _physics_process(delta):
	if state == states.FREE_FALL:
		velocity.y += 300*delta
		velocity.x = lerp(velocity.x, 0.0, 0.7*delta)
		position += velocity * delta
		rotation += rotation_speed * delta

func set_item_code(c):
	item_code = c

func _on_Area2D_area_entered(area):
	if state == states.FREE_FALL && area.get_parent().is_in_group("floor"):#hit floor when falling
		state = states.LANDED
		#global_position.y = area.global_position.y-16
		tween.interpolate_property(self, "modulate", modulate, Color(1,1,1,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.interpolate_callback(self, 0.5, "queue_free")
		tween.start()
		
		inventory.add_item(item_code)

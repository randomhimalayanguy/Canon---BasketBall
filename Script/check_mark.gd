extends Node2D

#Main Moto : To make a floating check mark when basket is scored

@export var time : float = 2
@export var dis := 10

@onready var sprite := $CheckMarkSprite

func _ready():
	var start_pos = position
	#Done using tween
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position", Vector2(start_pos.x, start_pos.y - dis), time)
	tween.tween_property(self, "position", Vector2(start_pos.x, start_pos.y + dis), time)

#So that sprite stays in correct orientation
func set_sprite(x, y):
	if(x < 0):
		sprite.scale.x *= -1
	elif(y<0):
		sprite.scale.y *= -1



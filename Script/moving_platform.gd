extends Node2D

#Main Moto : To have a moving platform/pole with hoop connected (along with it's signal)

@onready var timer := $Timer as Timer
@onready var wait_at_extreme_timer = $Timer2

@export_category("Movement")
@export var can_move = true
@export var dis_moving = 10
@export var move_rate := 0.1
@export var speed = 5
@export var wait_at_extreme := 1

@export_category("Hoop")
@export var hoop : Hoop

var wait = false
var starting_pos : Vector2
var dir := -1

signal scored


func _ready():
	timer.wait_time = move_rate
	starting_pos = position
	#If hoop is connected to pole, then emit the signal on it's behalf
	if hoop != null:
		hoop.connect("scored", func(): scored.emit())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_move and not wait:
		if (position.x < starting_pos.x - dis_moving or position.x > starting_pos.x + dis_moving):
			wait = true
			wait_at_extreme_timer.start()
			dir *= -1
		
		move()
		

func move():
	position.x += dir * speed
	can_move = false
	timer.start()


#Wait everytime, to make framerate independent
func _on_timer_timeout():
	can_move = true


#Wait at extremes positions
func _on_timer_2_timeout():
	wait = false

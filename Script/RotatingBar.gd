extends Node2D

#Main Moto : Similar to moving platform, it's rotating platform/bar/pole

@onready var wait_timer := $Wait_Timer as Timer
@onready var timer = $Timer as Timer

@export_category("Movement")
@export var can_rotate := true
@export var is_left_open := false
@export var max_deg := -60
@export var min_deg := 0
@export var move_angle := 2
@export var moving_rate := 0.1

@export_category("Hoop")
@export var hoop : Hoop

var wait = false
var can_move = true
var dir = 0

#Signal
signal scored

func _ready():
	dir = 1 if (max_deg - min_deg > 0) else -1
	timer.wait_time = moving_rate
	rotation_degrees = min_deg
	if hoop != null:
		hoop.connect("scored", func():
			scored.emit())
	

func _process(delta):
	if !can_rotate:
		return
	
	if can_move and not wait:
		if(is_left_open):
			if(rotation_degrees > max_deg || rotation_degrees < min_deg):
				wait = true
				wait_timer.start()
				dir *= -1
		#if right open
		else:
			if(rotation_degrees < max_deg || rotation_degrees > min_deg):
				wait = true
				wait_timer.start()
				dir *= -1
		
		rotation_degrees += dir * move_angle
		can_move = false
		timer.start()


#Wait to make frame indepenedent
func _on_timer_timeout():
	can_move = true

#Wait at extremes position
func _on_wait_timer_timeout():
	wait = false

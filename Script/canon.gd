class_name Canon
extends Node2D

#Main Moto -> Shoot balls, show trajectory of ball, and keep track of stats
#like remaining balls, power, angle

@export_category("Canon mechanics")
@export var change_rate := 0.1
@export var dir_length := 20
@export var total_balls := 5
@export var min_power := 20
@export var max_power := 50

@export_category("Trajectory calc")
@export var pts_dis := 10
@export var total_pts := 20

@export_category("Bal holder")
@export var ball_holder : Node2D

#All onready elements
@onready var timer = $Timer as Timer
@onready var prgbar = $Anchor/ProgressBar
@onready var anchor = $Anchor
@onready var ball_asset = preload("res://Assets/ball.tscn")
@onready var game_over_timer := $GameOverTimer


#Private variable
var power := 50
var deg := -45
var can_change = true
var balls_left : int

#Signals
signal value_changed(balls_left, power, angle)
signal game_over


func _ready():
	timer.wait_time = change_rate
	anchor.rotation_degrees = deg
	ball_holder.position = position
	prgbar.value = power

### Set by Game manager
func set_total_balls(balls):
	total_balls = balls
	balls_left = total_balls


func set_game_over_timer(t):
	game_over_timer.wait_time = t
###


#Drawing trajectory
func _draw():
	if balls_left > 0:
		for i in range(1, total_pts+1):
			draw_circle(Vector2(i*pts_dis, get_y(i*pts_dis)), 5, Color.ORANGE)

#Calc trajectory
func get_y(x):
	var p = power * dir_length * 1.34
	var y = (x * tan(deg_to_rad(deg))) + (980 * pow(x,2)) / ( pow(p, 2) * pow(cos(deg_to_rad(deg)),2))
	return y


#Taking inputs
func _input(event):
	if(event.is_action("ShootDirUp") and can_change):
		change_dir(-5)
	if(event.is_action("ShootDirDown") and can_change):
		change_dir(5)
	
	if(event.is_action("PowerIncrease") and can_change):
		change_power(5)
	if(event.is_action("PowerDecrease") and can_change):
		change_power(-5)
	
	if(event.is_action_pressed("Shoot") and balls_left > 0):
		shoot()


#To get dir (dir_length * unit lenght(of dir))
func get_dir():
	var dir = Vector2(dir_length*cos(deg_to_rad(deg)), dir_length*sin(deg_to_rad(deg)))
	return dir


#Change dir (change angle)
func change_dir(val):
	var t = deg
	deg += val
	#Clamping deg (upto -85)
	deg = clamp(deg, -85, 0)
	if(t != deg):
		queue_redraw()
	
	#Emitting signal to tell that value is changed
	value_changed.emit(balls_left, power, deg)
	#Timer and boolean to make it consistent (irrespective of frame rate)
	can_change = false
	timer.start()
	#Setting anchor to that deg
	anchor.rotation_degrees = deg


#Change power
func change_power(val):
	var t= power
	power += val
	power = clamp(power, min_power, max_power)
	if(t != power):
		queue_redraw()
	
	#Emitting singal to show value is changed
	value_changed.emit(balls_left, power, deg)
	prgbar.value = power
	can_change = false
	timer.start()


#Shoot balls, spawn balls and apply impluse at calculated dir
func shoot():
	var ball = ball_asset.instantiate() as RigidBody2D
	ball_holder.add_child(ball)
	ball.apply_impulse(get_dir() * power)
	balls_left -= 1
	if(balls_left == 0):
		game_over_timer.start()
	value_changed.emit(balls_left, power, deg)


func _on_timer_timeout():
	can_change = true


#If no balls remain, send singal
func _on_game_over_timer_timeout():
	game_over.emit()

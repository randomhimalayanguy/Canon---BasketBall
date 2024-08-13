class_name Hoop
extends Node2D

#Main Moto : Emit signal when basket is scored

var has_scored = false	#Don't allow scoring if already done
#There are two triggers, basket is given when both trigger activated, and first one is activated before second
var first_done = false

#Reset timer, so that if only first trig is activated and not second one, wait for some time, and mark first one false as well
@onready var reset_timer := $Wrong_hoop_reset_timer
@onready var check_mark := $CheckMark
@onready var player := $AudioStreamPlayer

#Signal
signal scored


func _ready():
	#To correct orientation of check_mark
	check_mark.set_sprite(scale.x, scale.y)


#First trigger
func _on_trigger_enter(body):
	first_done = true
	reset_timer.start()

#Second trigger
func _on_trigger_2_body_entered(body):
	if !has_scored and first_done:
		has_scored = true
		check_mark.visible = true
		player.play()
		emit_signal("scored")


#To reset if first trigg is hit, and not second
func _on_wrong_hoop_reset_timer_timeout():
	if not has_scored:
		first_done = false

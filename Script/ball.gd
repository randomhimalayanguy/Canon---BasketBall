extends RigidBody2D

#Main Moto is to play sound when collision occurs
@export var audio_effect_vel := 5
@onready var audioplayer := $AudioStreamPlayer

var is_playing = false
var can_play = true


func _on_body_entered(body):
	#If colliding with StaticBody2D and linear vel > specified vel -> play sound
	if(body.name == "StaticBody2D"  and not is_playing and can_play):
		if(abs(linear_velocity.x) > audio_effect_vel || abs(linear_velocity.y) > audio_effect_vel):
			#Sound Level depends on linear vel
			audioplayer.volume_db = min(8, max(linear_velocity.x, linear_velocity.y) * 1/50)
			audioplayer.play()
			is_playing = true


#If already playing
func _on_audio_stream_player_finished():
	is_playing = false


#Don't play sound after a while
func _on_timer_timeout():
	can_play = false

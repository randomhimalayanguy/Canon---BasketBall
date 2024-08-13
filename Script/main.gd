extends Node2D

#Main Moto : Main Menu UI

@onready var play_guide := $CanvasLayer/GameControlsPanel

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")


func _on_how_to_play_button_pressed():
	play_guide.visible = true


func _on_quit_button_pressed():
	get_tree().quit()

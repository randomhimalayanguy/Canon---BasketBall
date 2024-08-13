class_name  MainUi
extends Control

#Main Moto : To show all UI -> Stats, Retry, Next level and Game over

@onready var stats_label := $StatPanel/StatsLabel
@onready var reload_panel := $RetryUI
@onready var next_level_panel := $NextLevelUI
@onready var game_completed_panel := $GameOverUI
@onready var timer := $Timer

#Store next level
var next_level : PackedScene

func _ready():
	reload_panel.visible = false
	next_level_panel.visible = false
	game_completed_panel.visible = false


#To display stats in correct format
func stats(ball_count :int, power :int, angle :int):
	stats_label.text = "Balls Remaining : %d || Power : %d || Angle  : %d°" %[ball_count, power, angle]


func show_reload_ui():
	reload_panel.show()

func show_next_level_ui():
	timer.start()


func set_next_level(level : PackedScene):
	next_level = level


##Buttons
func _on_next_level_pressed():
	get_tree().change_scene_to_packed(next_level)


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Assets/main.tscn")


func _on_retry_button_pressed():
	get_tree().reload_current_scene()


#Wait for some time when level is completed
func _on_timer_timeout():
	if next_level == null:
		game_completed_panel.show()
	else:
		next_level_panel.show()

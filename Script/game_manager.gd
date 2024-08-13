extends Node2D

#Main Moto : To control the flow of Data between diff nodes (like canon, ui, etc.)
#and load next level or to show retry etc

#Using export category
@export_category("Controller")
@export var total_balls := 5
@export var wait_after_over_time := 5

@export_category("Resources")
@export var hoops : Node
@export var canon : Canon
@export var ui : MainUi
@export var next_level : PackedScene

var total_hoops = 0
var cur_score = 0

func _ready():
	##Canon
	canon.connect("value_changed", _on_value_change)	#Connecting to signal
	canon.connect("game_over", _on_game_over)	#Connecting to signal
	canon.set_total_balls(total_balls)	#Setting total balls
	canon.set_game_over_timer(wait_after_over_time)	#Setting timer for game over
	
	##UI
	ui.stats(total_balls, 50, 45)
	if next_level != null:
		ui.set_next_level(next_level)
	
	##Hoops
	total_hoops = hoops.get_child_count()
	#get_balls()
	for node in hoops.get_children():
		node.connect("scored", _on_basket)


#Connected to canon's signal and change value of UI 
func _on_value_change(ball_left, power, angle):
	ui.stats(ball_left, power, -angle)


#If all baskets are not scored, show game over 
func _on_game_over():
	if(cur_score != total_hoops):
		ui.show_reload_ui()


#If basket occurs, increase score
func _on_basket():
	cur_score += 1
	if(cur_score == total_hoops):
		ui.show_next_level_ui()


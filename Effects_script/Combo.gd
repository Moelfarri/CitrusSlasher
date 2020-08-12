extends Node


var multiple_combo_timer = 0
var time_between_orange_slices = 0
var oranges_sliced_counter = 0
var is_combo = false
var combos_in_a_row = 0
var combo

func _process(_delta):
	combo = oranges_sliced_counter
	if oranges_sliced_counter >= 2 and time_between_orange_slices <= 8:
		is_combo = true
		oranges_sliced_counter = 0
		multiple_combo_timer = 0
		
		combos_in_a_row += 1 
		if combos_in_a_row == 4:
			combos_in_a_row = 4
		
	else:
		is_combo = false
		
	
	#Timer and timeout for single combo
	time_between_orange_slices += 1
	if time_between_orange_slices >= 5:
		time_between_orange_slices = 0
		oranges_sliced_counter = 0
	
	#Timer and timeout for multiple combos
	multiple_combo_timer += 1
	if multiple_combo_timer >= 100:
		multiple_combo_timer = 0
		combos_in_a_row = 0



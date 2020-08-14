extends Node2D


func _on_orange_sliced(given_position, given_angle):
	pass


func _on_LevelSelectorArea_body_exited(body):
	MainThemeController.get_node("CitrusSlasherMainTheme").stop()
	
	if "EndlessModeOrange" in body.get_parent().name:
		get_tree().change_scene("res://StageEndlessMode.tscn")

	elif "TimeModeOrange" in body.get_parent().name:
		get_tree().change_scene("res://Source_script/StageTimeMode.tscn")

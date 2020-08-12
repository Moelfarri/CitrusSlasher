extends Control



func _ready():
	Global.load_highscore()
	Global.reset_score()
	OS.low_processor_usage_mode = false
	$MainThemeSoundtrack.play()



func _on_MainThemeSoundtrack_finished():
	$MainThemeSoundtrack.play()

#WHEN PRESSED MOVE TO STAGE SCENE ALSO DO ARRGH LAUGHING PIRATE TRACK
func _on_PlayButton_pressed():
	get_tree().change_scene("res://StageEndlessMode.tscn")



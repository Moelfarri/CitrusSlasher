extends Node2D

var gameoverScore = 0

func _ready():
	OS.low_processor_usage_mode = false
	$AnimationPlayer.play("FadeIn")

	
		#Save new highscore
	if Global.score > Global.highscore:
		Global.highscore = Global.score
		Global.save_highscore()

func _process(_delta):
	$Dashboard.visible = true


func _on_ReturnButton_pressed():
	get_tree().change_scene("res://UI_script/Main Menu.tscn")


func _on_Timer_timeout():
	if not $AnimationPlayer.is_playing():
		
		
		#COUNTING SCORE EFFECT
		if gameoverScore != Global.score:
			gameoverScore += 1
			$Dashboard/Score.text = str(gameoverScore) + "x"
		else:
			$Dashboard/Score.text = str(Global.score) + "x"
			$Dashboard/HighScore.visible = true
			$Dashboard/HighScore.text = str(Global.highscore) + "x"

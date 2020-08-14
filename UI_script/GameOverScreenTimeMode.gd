extends Node2D


func _ready():
	Global.is_time_mode = false
	OS.low_processor_usage_mode = false
	$AnimationPlayer.play("FadeIn")
	$Dashboard/Grade.text = Global.grade

	if Global.is_time_out:
		$GameOverText.visible = false
		$TimeOutText.visible = true
		Global.is_time_out = false #to reset it
		$TimeOutBellSfx.play()
 
func _process(_delta):
	$Dashboard.visible = true
	
func _on_ReturnButton_pressed():
	get_tree().change_scene("res://UI_script/Main Menu.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeIn":
		$Dashboard/Grade.visible = true

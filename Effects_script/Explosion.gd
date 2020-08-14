extends AnimatedSprite



func _ready():
	OS.low_processor_usage_mode = false  #stops glitching in android
	get_tree().paused = true
	$MetalClangSfx.play()






func _on_MetalClangSfx_finished():
	$BombExplodeSfx.play()
	play("Explode")


func _on_BombExplodeSfx_finished():
	get_tree().paused = false
	if Global.is_time_mode:
		get_tree().change_scene("res://UI_script/GameOverScreenTimeMode.tscn")
	else:
		get_tree().change_scene("res://UI_script/GameOverScreen.tscn")


func _on_Explosion_animation_finished():
	stop()


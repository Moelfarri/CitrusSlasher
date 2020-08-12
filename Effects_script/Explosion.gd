extends AnimatedSprite



func _ready():
	get_tree().paused = true
	$MetalClangSfx.play()






func _on_MetalClangSfx_finished():
	$BombExplodeSfx.play()
	play("Explode")


func _on_BombExplodeSfx_finished():
	get_tree().paused = false
	get_tree().change_scene("res://UI_script/GameOverScreen.tscn")


func _on_Explosion_animation_finished():
	stop()


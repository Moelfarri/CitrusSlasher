extends Sprite



func _ready():
	$AnimationPlayer.play("FadeAway")
	$LifeLostSfx.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeAway":
		queue_free()

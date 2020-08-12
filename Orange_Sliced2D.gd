extends Node2D


func _ready():
	$OrangeSlicedSoundEffect.play()

func _process(delta):
	var texture = $Viewport.get_texture()
	$RigidBody2D/OrangeLeftSlice.texture = texture
	$RigidBody2D2/OrangeRightSlice.texture = texture



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

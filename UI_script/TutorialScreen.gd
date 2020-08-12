extends Node2D


func _ready():
	get_node("Orange2D/Sprite").set_scale(Vector2(2,2))




func _on_orange_sliced():
	$LaughingPirateSoundEffect.play()



func _on_LaughingPirateSoundEffect_finished():
	get_tree().change_scene("res://Stage.tscn")

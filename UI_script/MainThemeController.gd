extends Control


func _ready():
	$CitrusSlasherMainTheme.play()


func _on_CitrusSlasherMainTheme_finished():
	$CitrusSlasherMainTheme.play()

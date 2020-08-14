extends Node2D

#Known bugs:
# Sometimes the 4 in a row combo thing just stops playing if the threshold is gone beyond 100
# Orange2D and swordslash sometimes the physics process overrides the area2d such that a cut does not occur and instead the orange is thrown away





#TODO
#RIGHT NOW:
#Bug fixes: 
#Grade is giving F if not A+ or B or C find how to give E and D. 



#SHOP: 
#BUY UPGRADE THAT DONT DO SHIT -> CURE SCURVEY 
##add Citrus CURRENCY "ALL CITRUSES SLASHED OVER LIFETIME OF PLAYING"
#using to buy "cure scurvy"


#CLEAN UP IN DOCUMENT NAMES AND FILE NAMES


#Testing:
#Test on phone

#RELEASE:
#CREATE ARTSTYLE AND ICONS AND RELASE ONTO GOOGLE PLAYSTORE

func _ready():
	Global.load_highscore()
	Global.reset_score()
	OS.low_processor_usage_mode = false



#WHEN PRESSED MOVE TO STAGE SCENE ALSO DO ARRGH LAUGHING PIRATE TRACK
func _on_PlayButton_pressed():
	get_tree().change_scene("res://UI_script/LevelSelectionScreen.tscn")



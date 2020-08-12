extends Node2D
#Known bugs:
# Sometimes the 4 in a row combo thing just stops playing if the threshold is gone beyond 100
# Orange2D and swordslash sometimes the physics process overrides the area2d such that a cut does not occur and instead the orange is thrown away

#BUGS I WANT TO FIX:
#Remove_life gir noen ganger error siden texturen lages av appelsninen, finn en lurere måte å gjøre det på


#TODO
#RIGHT NOW:
#MORE DIFFERENT IMPULSES ON ORANGE SPAWNS



#DIFFERENT MODES:
	#1.TIME MODE:
# 30 second timer!
# ORANGES SPAWN IN WAVES
#ORANGE SPAWNING DELAYMENT SO THEY DONT SPAWN AS YOU CUT ONE ORANGE
# ADD GRADING (NO HIGHSCORE)

	#2.ENDLESS MODE:
#THINGS JUST SPAWN ENDLESSLY, LIKE A TRAINING MODE.
#HIGSCORE

#SHOP: 
#BUY UPGRADE THAT DONT DO SHIT -> CURE SCURVEY 
##add Citrus CURRENCY "ALL CITRUSES SLASHED OVER LIFETIME OF PLAYING"
#using to buy "curce scurvy



#REVAMP CODE:
#REMOVE THE "TUTORIAL SCREEN AND CHANGE INTO - TIME MODE VS ENDLESS MODE"
#CLEAN UP STAGE SOUND NODES
#CLEAN UP IN DOCUMENT NAMES AND FILE NAMES
#MAKE SWORD INTO AN INSTANCE BASED ON CLICKS THAN IT EXISTING NONSTOP THIS WAY YYOU CAN HAVE MULTIPLE INSTANCES ON ANDROID?




#Testing:
#Test on phone



#Objects
const ORANGE = preload("res://Orange2D.tscn")
const ORANGE_SLICE = preload("res://Orange_Sliced2D.tscn")
const BOMB = preload("res://2DTextures/Bomb2D.tscn")

#Effects
const EXPLOSION = preload("res://Effects_script/Explosion.tscn")
const SPLAT = preload("res://Effects_script/Splat.tscn")
const ONECOMBOx = preload("res://Effects_script/1xCombos.tscn")
const TWOCOMBOx = preload("res://Effects_script/2xCombos.tscn")
const THREECOMBOx = preload("res://Effects_script/3xCombos.tscn")
const FOURCOMBOx = preload("res://Effects_script/4xCombos.tscn")
const TWOx = preload("res://Effects_script/2x.tscn")
const THREEx = preload("res://Effects_script/3x.tscn")
const FOURx = preload("res://Effects_script/4x.tscn")
const LIFE_LOST = preload("res://Effects_script/LifeLost.tscn")
const LIFE_ADDED = preload("res://Effects_script/LifeAdded.tscn")


var orange_sliced_position = Vector2()
var	orange_sliced_angle = 0.0
var oranges_spawned = 0
var orange_threshold = 2

var is_bomb_sliced = false
var bomb_sliced_position = Vector2()

var random_generator = RandomNumberGenerator.new()
var lives = 3 


enum SPAWNER{FAR_LEFT, LEFT,  MIDDLE, FAR_RIGHT, RIGHT}



func _ready():
	OS.low_processor_usage_mode = true
	random_generator.randomize()
	
	
	if AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")):
		$MuteButton.visible = false
		$UnmuteButton.visible = true


func _process(delta):
	
	#Score display
	$ScoreCounterText.text = str(Global.score) + "x"
	
	
	#Win/Lose Conditions
	display_lives_left()
	game_over()
	
	
	#Orange spawning sequence
	if oranges_spawned != orange_threshold:
		randomly_spawn_and_project_orange()
		oranges_spawned += 1
	
	
	#COMBO GRAPHICS AND SOUNDS
	if Combo.is_combo:
		generate_sliced_oranges_combo_texture(Combo.combo)
		generate_multiple_combo_texture(Combo.combos_in_a_row)
		match Combo.combos_in_a_row:
			1:
				if not get_node("LaughComboSoundEffect"+str(Combo.combos_in_a_row)).is_playing() and not $LaughComboSoundEffect4.is_playing():
					$LaughComboSoundEffect1.play()
			2:
				$LaughComboSoundEffect1.stop()
				if not get_node("LaughComboSoundEffect"+str(Combo.combos_in_a_row)).is_playing():
					$LaughComboSoundEffect2.play()
			3:
				$LaughComboSoundEffect2.stop()
				if not get_node("LaughComboSoundEffect"+str(Combo.combos_in_a_row)).is_playing():
					$LaughComboSoundEffect3.play()
			4:
				$LaughComboSoundEffect3.stop()
				if not get_node("LaughComboSoundEffect"+str(Combo.combos_in_a_row)).is_playing():
					$LaughComboSoundEffect4.play()
					
					#give life 
					if lives < 3: 
						add_life()
 



###############COMBO MANGEMENT##################
func generate_sliced_oranges_combo_texture(sliced_oranges):
	var angle = orange_sliced_angle
	
	#so we dont get upside down text
	if angle >= 45:
		angle = 45
	elif angle <= -45:
		angle = -45
		
	match sliced_oranges:
		2:
			var two = TWOx.instance()
			two.position = orange_sliced_position + Vector2(-100, 0)
			two.rotation_degrees = angle
			add_child(two)
		3:
			var three= THREEx.instance()
			three.position = orange_sliced_position + Vector2(-100, 0)
			three.rotation_degrees = angle
			add_child(three)
		4:
			var four = FOURx.instance()
			four.position = orange_sliced_position + Vector2(-100, 0)
			four.rotation_degrees = angle
			add_child(four)


#combotextures instances get generated based on how many in a row have been sliced so far
func generate_multiple_combo_texture(combos_in_a_row):
	
	match combos_in_a_row:
		1:
			var one = ONECOMBOx.instance()
			one.position = orange_sliced_position + Vector2(20,0)
			add_child(one)
		2:
			var two = TWOCOMBOx.instance()
			two.position = orange_sliced_position + Vector2(20,0)
			add_child(two)
			
		3:
			var three = THREECOMBOx.instance()
			three.position = orange_sliced_position + Vector2(20,0)
			add_child(three)
		4:
			var four = FOURCOMBOx.instance()
			four.position = orange_sliced_position + Vector2(20,0)
			add_child(four)


###############LIFE MANGEMENT##################
func display_lives_left():
	match lives:
		3:
			$CanvasLayer/Lives.play("3 Lifes")
		2:
			$CanvasLayer/Lives.play("2 Lifes")
		1:
			$CanvasLayer/Lives.play("1 Life")
		0:
			$CanvasLayer/Lives.play("Game Over")


func add_life():
	lives += 1
	var added_life = LIFE_ADDED.instance()
	add_child(added_life)
	$AddLifeSoundEffect.play()


func remove_life():
	lives -= 1
	var lost_life = LIFE_LOST.instance()
	get_parent().add_child(lost_life) #since it is used in orange2d we need to use get_parent()
	$LostLifeSoundEffect.play()
	

###############ORANGE MANGEMENT##################
func randomly_spawn_and_project_orange():
	var orange = ORANGE.instance()
	var random_position = random_generator.randi_range(0,4)
	
	match random_position:
		SPAWNER.FAR_LEFT:
			orange.position = $Spawners/FarLeftSpawner.position
			orange.apply_central_impulse(Vector2(250,-400))
			$OrangeThrowSoundEffect.pitch_scale = 0.8
		SPAWNER.LEFT:
			orange.position = $Spawners/LeftSpawner.position
			orange.apply_central_impulse(Vector2(100,-400))
			$OrangeThrowSoundEffect.pitch_scale = 0.9
		SPAWNER.MIDDLE:
			orange.position = $Spawners/MiddleSpawner.position
			orange.apply_central_impulse(Vector2(0,-400))
			$OrangeThrowSoundEffect.pitch_scale = 1.0
		SPAWNER.RIGHT:
			orange.position = $Spawners/RightSpawner.position
			orange.apply_central_impulse(Vector2(-100,-400))
			$OrangeThrowSoundEffect.pitch_scale = 1.1
		SPAWNER.FAR_RIGHT:
			orange.position = $Spawners/FarRightSpawner.position
			orange.apply_central_impulse(Vector2(-250,-400))
			$OrangeThrowSoundEffect.pitch_scale = 1.2
	
	orange.set_z_index(1)
	add_child(orange)
	$OrangeThrowSoundEffect.play()


func _on_orange_sliced(given_position, given_sliced_angle):
	orange_sliced_position = given_position
	orange_sliced_angle = given_sliced_angle
	
	
###############BUTTONS##################
func _on_PauseButton_pressed():
	$PauseButton.visible = false
	$ResumeButton.visible = true
	get_tree().paused = true


func _on_ResumeButton_pressed():
	$PauseButton.visible = true
	$ResumeButton.visible = false
	get_tree().paused = false


func _on_MuteButton_pressed():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)  
	$MuteButton.visible = false
	$UnmuteButton.visible = true


func _on_UnmuteButton_pressed():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)  
	$MuteButton.visible = true
	$UnmuteButton.visible = false


###############BOMB##################
func _on_BombSpawnTimer_timeout():
	var bomb = BOMB.instance()
	var random_position = random_generator.randi_range(0,4)
	
	match random_position:
		SPAWNER.FAR_LEFT:
			 bomb.position = $Spawners/FarLeftSpawner.position
			 bomb.apply_central_impulse(Vector2(250,-400))
		SPAWNER.LEFT:
			bomb.position = $Spawners/LeftSpawner.position
			bomb.apply_central_impulse(Vector2(100,-400))
		SPAWNER.MIDDLE:
			bomb.position = $Spawners/MiddleSpawner.position
			bomb.apply_central_impulse(Vector2(0,-400))
		SPAWNER.RIGHT:
			bomb.position = $Spawners/RightSpawner.position
			bomb.apply_central_impulse(Vector2(-100,-400))
		SPAWNER.FAR_RIGHT:
			bomb.position = $Spawners/FarRightSpawner.position
			bomb.apply_central_impulse(Vector2(-250,-400))
	
	bomb.set_z_index(1)
	add_child(bomb)


func _on_bomb_sliced(given_position):
	bomb_sliced_position = given_position
	
###############GAME OVER MANAGEMENT##################
func game_over():
		if lives <= 0:
			get_tree().change_scene("res://UI_script/GameOverScreen.tscn")
		elif is_bomb_sliced:
			var explosion = EXPLOSION.instance()
			explosion.position = bomb_sliced_position
			explosion.set_z_index(2)
			add_child(explosion)
			set_process(false)
		else:
			return

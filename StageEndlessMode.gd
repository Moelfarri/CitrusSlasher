extends Node2D
#Known bugs:
# Sometimes the 4 in a row combo thing just stops playing if the threshold is gone beyond 100
# Orange2D and swordslash sometimes the physics process overrides the area2d such that a cut does not occur and instead the orange is thrown away




#TODO
#RIGHT NOW:
#Remove_life gir noen ganger error siden texturen lages av appelsninen, finn en lurere måte å gjøre det på

#DIFFERENT MODES:
	#1.TIME MODE:
# 30 second timer!
# ORANGES SPAWN IN WAVES
# ADD GRADING (NO HIGHSCORE)
#if lose no lfie = A+ , LOSE 1 life B, lose 2 lives C lose 3 lives or bomb gets F



#SHOP: 
#BUY UPGRADE THAT DONT DO SHIT -> CURE SCURVEY 
##add Citrus CURRENCY "ALL CITRUSES SLASHED OVER LIFETIME OF PLAYING"
#using to buy "curce scurvy




#REVAMP CODE:
# CHANGE INTO - TIME MODE VS ENDLESS MODE" LET MAIN SCREEN GO TO IT AND U SLASH WHICH ONE U WANT
#CLEAN UP IN DOCUMENT NAMES AND FILE NAMES


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

#UI
const PAUSE_DASHBOARD = preload("res://UI_script/PauseDashboard.tscn")

var orange_sliced_position = Vector2()
var	orange_sliced_angle = 0.0
var oranges_spawned = 0
var orange_threshold = 1

var is_bomb_sliced = false
var bomb_sliced_position = Vector2()

var random_generator = RandomNumberGenerator.new()
var lives = 3 

var spawn_timer = 0
var timer_threshold = 600

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
	orange_spawn_timer()
	if oranges_spawned != orange_threshold and not orange_threshold == 0:
		var spawn_probability = random_generator.randf_range(1,100)
		#2.5% change of spawning a bomb instead 
		if spawn_probability <= 97.5:
			randomly_spawn_and_project_orange()
			oranges_spawned += 1
		else:
			randomly_spawn_and_project_bomb()

	
	
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


func remove_life():
	lives -= 1
	var lost_life = LIFE_LOST.instance()
	add_child(lost_life) #since it is used in orange2d we need to use get_parent()


###############ORANGE MANGEMENT##################
func randomly_spawn_and_project_orange():
	var orange = ORANGE.instance()
	var random_position = random_generator.randi_range(0,4)
	var binary_horisontal_impulse = random_generator.randi_range(0,1)
	
	match random_position:
		SPAWNER.FAR_LEFT:
			orange.position = $Spawners/FarLeftSpawner.position
			orange.apply_central_impulse(Vector2(250,-400))
			$OrangeThrowSoundEffect.pitch_scale = 0.8
		SPAWNER.LEFT:
			orange.position = $Spawners/LeftSpawner.position
			if binary_horisontal_impulse == 0:
				orange.apply_central_impulse(Vector2(100,-400))
			else:
				orange.apply_central_impulse(Vector2(0,-400))
			$OrangeThrowSoundEffect.pitch_scale = 0.9
		SPAWNER.MIDDLE:
			orange.position = $Spawners/MiddleSpawner.position
			orange.apply_central_impulse(Vector2(0,-400))
			$OrangeThrowSoundEffect.pitch_scale = 1.0
		SPAWNER.RIGHT:
			orange.position = $Spawners/RightSpawner.position
			if binary_horisontal_impulse == 0:
				orange.apply_central_impulse(Vector2(-100,-400))
			else:
				orange.apply_central_impulse(Vector2(0,-400))
			$OrangeThrowSoundEffect.pitch_scale = 1.1
		SPAWNER.FAR_RIGHT:
			orange.position = $Spawners/FarRightSpawner.position
			orange.apply_central_impulse(Vector2(-250,-400))
			$OrangeThrowSoundEffect.pitch_scale = 1.2
	
	orange.set_z_index(1)
	add_child(orange)
	$OrangeThrowSoundEffect.play()


func orange_spawn_timer():
	spawn_timer += 1
	if spawn_timer >= timer_threshold:
		spawn_timer = 0
		if timer_threshold == 600:
			orange_threshold = 0
			timer_threshold = 150
		else:
			var threshold_probability = random_generator.randf_range(1,100)
			if threshold_probability <= 50:
				set_orange_spawn_threshold(1)
			elif threshold_probability > 50 and threshold_probability <= 90:
				set_orange_spawn_threshold(2)
			elif threshold_probability > 90 and threshold_probability <= 97.5:
				set_orange_spawn_threshold(3)
			else:
				set_orange_spawn_threshold(4)
			timer_threshold = 600


func _on_orange_sliced(given_position, given_sliced_angle):
	orange_sliced_position = given_position
	orange_sliced_angle = given_sliced_angle


func set_orange_spawn_threshold(threshold):
	orange_threshold = threshold

###############BUTTONS##################
func _on_PauseButton_pressed():
	$PauseButton.visible = false
	$ResumeButton.visible = true
	var pause_dashboard = PAUSE_DASHBOARD.instance()
	add_child(pause_dashboard)
	get_tree().paused = true



func _on_ResumeButton_pressed():
	$PauseButton.visible = true
	$ResumeButton.visible = false
	get_node("PauseDashboard").queue_free()
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
func  randomly_spawn_and_project_bomb():
	var bomb = BOMB.instance()
	var random_position = random_generator.randi_range(1,4)
	
	match random_position:
		SPAWNER.FAR_LEFT:
			 bomb.position = $Spawners/FarLeftSpawner.position
			 bomb.apply_central_impulse(Vector2(250,-400))
		SPAWNER.LEFT:
			bomb.position = $Spawners/LeftSpawner.position
			bomb.apply_central_impulse(Vector2(100,-400))
		SPAWNER.MIDDLE:
			bomb.position = $Spawners/LeftSpawner.position
			bomb.apply_central_impulse(Vector2(0,-200))
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





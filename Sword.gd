extends KinematicBody2D

const SLASH_SPEED = 7


var velocity = 0.0
var new_position = Vector2()
var previous_position = Vector2()

var random_generator = RandomNumberGenerator.new()


func _process(delta):
	#cutting only happens with certain speed
	var random_pitch = random_generator.randf_range(0.6, 1.0)
	if velocity > SLASH_SPEED:
		$CollisionShape2D.disabled = false
		if not $SwordSoundEffect.is_playing() and velocity > 20:
			$SwordSoundEffect.pitch_scale = random_pitch
			$SwordSoundEffect.play()
		
	else: 
		$CollisionShape2D.disabled = true

	if  Input.is_mouse_button_pressed(1):
		previous_position = position
		position = get_global_mouse_position()
		new_position = position
		velocity = (new_position - previous_position).length()
		$Trail2D.trail_length = 15
	else:
		velocity = 0
		$Trail2D.trail_length = 0

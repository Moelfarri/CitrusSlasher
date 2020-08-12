extends RigidBody2D

const ORANGE_SLICE = preload("res://Orange_Sliced2D.tscn")
const SPLAT = preload("res://Effects_script/Splat.tscn")


var is_orange_sliced = false
var orange_position = Vector2()
var orange_sliced_angle = 0.0
var random_generator = RandomNumberGenerator.new()

 
signal orange_is_sliced(given_position, given_sliced_angle)


func _ready():
		connect("orange_is_sliced", get_parent(), "_on_orange_sliced")
	
	
func _process(delta):
	var texture = $Viewport.get_texture()
	$Sprite.texture = texture
	
	#Create a sliced orange object if it is sliced	
	if is_orange_sliced: 
		var orange_slice = ORANGE_SLICE.instance()
		var splat = SPLAT.instance()
		
		orange_slice.set_global_position(orange_position)
		orange_slice.set_rotation_degrees(orange_sliced_angle)
		orange_slice.set_z_index(1)
		splat.set_global_position(orange_position)
	
		#create random angle on the texture of the sliced orange, possible to use a RigidBody and alter the angular velocity instead,i like this though
		var random_negative_angle = -random_generator.randi_range(0,45)
		orange_slice.get_node("Viewport/OrangeSliceTexture3D/OrangeSlice3D").set_rotation_degrees(Vector3(0,random_negative_angle,0))
		
		if get_parent().name == "TutorialScreen":
			orange_slice.get_node("RigidBody2D/OrangeLeftSlice").set_scale(Vector2(2,2))
			orange_slice.get_node("RigidBody2D2/OrangeRightSlice").set_scale(Vector2(2,2))
			
		#Add instance of sliced orange in the parent scene
		get_parent().add_child(orange_slice)
		get_parent().add_child(splat)
		
		#score management
		if not get_parent().name == "TutorialScreen":
			Global.increment_score()
			Combo.oranges_sliced_counter += 1
		
		#remove the "whole" orange scene as it is sliced now"
		queue_free()



func _on_OrangeArea_body_entered(body):
	if "Sword" in body.name:
		$CollisionShape2D2.set_deferred("disabled", true)
		#We find the relative position of the sword_vector to the center of the orange and calculate the angle 
		var sword_slice_position = get_parent().get_node("CanvasLayer/Sword").get_position()
		var sliced_angle = rad2deg(sword_slice_position.angle_to_point(position))
		is_orange_sliced = true
		emit_signal("orange_is_sliced", sword_slice_position, sliced_angle)

		orange_position = get_global_position()
		orange_sliced_angle = sliced_angle


#called when orange exits the screen, meaning also in the event of it being cut.
func _on_VisibilityNotifier2D_screen_exited():
	if get_parent().name == "StageEndlessMode":
		get_parent().oranges_spawned -= 1
		if not is_orange_sliced:
			get_parent().remove_life()
			return
		queue_free()
		
	elif get_parent().name == "TutorialScreen":
		set_global_position(Vector2(255, 150))
		set_linear_velocity(Vector2(0,0))
		$CollisionShape2D2.set_deferred("disabled", false)


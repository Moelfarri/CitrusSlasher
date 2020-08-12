extends RigidBody2D



signal bomb_is_sliced(given_position)

func _ready():
	$BombFuseSfx.play()
	connect("bomb_is_sliced", get_parent(), "_on_bomb_sliced")


func _process(delta):
	var texture = $Viewport.get_texture()
	$Sprite.texture = texture
	
	if get_linear_velocity().y > 0:
		$CollisionShape2D.disabled = true
	


func _on_BombArea2D_body_entered(body):
	if "Sword" in body.name:
		$CollisionShape2D.set_deferred("disabled", true)
		get_parent().is_bomb_sliced = true
		var sword_slice_position = get_parent().get_node("CanvasLayer/Sword").get_position()
		emit_signal("bomb_is_sliced", sword_slice_position)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

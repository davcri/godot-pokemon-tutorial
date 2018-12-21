extends RigidBody2D


func _process(delta):
	var colliders = get_colliding_bodies()
	
	for collider in colliders:
		# se il collider è un pokemon
		if "Pokemon" in collider.get_groups() and not $AnimationPlayer.is_playing():
			$Sounds/Hit.play()
			$Sounds/AbsorbingPokemon.play()
			collider.capture()
			mode = RigidBody2D.MODE_STATIC
			# needed because otherwise "set_rotation(0)" does not have any effect
			look_at(Vector2())  # note: it doesn't matter what you pass
			set_rotation(0)
			$AnimationPlayer.play("capture")
			yield(get_tree().create_timer(3.4), "timeout")
			$Sounds/PokemonCaught.play()

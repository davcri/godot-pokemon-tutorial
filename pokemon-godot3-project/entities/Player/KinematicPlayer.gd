extends KinematicBody2D

var pokeball_count = 0

signal pokeball_taken
signal pokeball_thrown
signal dialogue_started


func _ready():
	pass


func _process(delta):
	# Inizializzo il vettore "velocity"
	var velocity = Vector2()
		
	# Aggiorno il vettore velocity in base all'input del giocatore
	if Input.is_key_pressed(KEY_UP):
		velocity.y = -1
		$RayCast2D.cast_to = Vector2(0, -50)
	if Input.is_key_pressed(KEY_DOWN):
		velocity.y = 1
		$RayCast2D.cast_to = Vector2(0, 50)
	if Input.is_key_pressed(KEY_LEFT):
		velocity.x = -1
		$RayCast2D.cast_to = Vector2(-50, 0)
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x = 1
		$RayCast2D.cast_to = Vector2(50, 0)
	
	var movement = 250*velocity.normalized()*delta
	
	self.move_and_collide(movement)
	self.updateAnimatedSprite(velocity)
		
	# lancio pokeball
	if pokeball_count > 0 and $PokeballCooldown.time_left == 0 and Input.is_key_pressed(KEY_E):
		# avvio il timer di cooldown
		$PokeballCooldown.start()
		# lancio pokeball (istanzia un nuovo nodo nella scena)
		launch_pokeball()
		# decrementa pokeball_count
		pokeball_count -= 1
		# emetti un segnale per aggiornare la GUI
		emit_signal("pokeball_thrown", pokeball_count)
		$PokeballThrownSound.play()
		
	# se il raycast ha una collisione con un oggetto
	if $RayCast2D.is_colliding():
		# salva il collider in una variabile
		var collider = $RayCast2D.get_collider()
		# se il collider è una pokeball ed abbiamo premuto il tasto spazio
		if collider != null and Input.is_key_pressed(KEY_SPACE) and "Pokeball" in collider.name:
			# "raccogli" la pokeball
			collider.queue_free()  # elimina il nodo dalla scena
			pokeball_count += 1
			emit_signal("pokeball_taken", pokeball_count)
		# se il collider è un NPC
		if collider != null and Input.is_action_just_released("ui_accept") and "NPC" in collider.name:
			emit_signal("dialogue_started", collider.dialogue_text)
			$AnimatedSprite.stop()
			set_process(false)


func updateAnimatedSprite(velocity):
	if velocity.x == -1:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play('walk_left')
	elif velocity.x == 1:
		# specchia la sprite per creare l'animazione di camminata verso destra
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play('walk_left')
	elif velocity.y == -1:
		$AnimatedSprite.play('walk_up')
	elif velocity.y == 1:
		$AnimatedSprite.play('walk_down')
	
	if velocity == Vector2():
		# se il giocatore si stava spostando verso sinistra
		if $AnimatedSprite.animation == 'walk_left':
			$AnimatedSprite.play('stand_left')
		elif $AnimatedSprite.animation == 'walk_up':
			$AnimatedSprite.play('stand_up')
		elif $AnimatedSprite.animation == 'walk_down':
			$AnimatedSprite.play('stand_down')
			
			
func launch_pokeball():
	# carica la scena Pokeball
	var pokeball_scene = load("res://entities/Pokeball/Pokeball.tscn")
	# instanzia la scena in un nodo
	var pokeball_node = pokeball_scene.instance()
	# imposta le proprietà posizione, velocità lineare ed angolare
	pokeball_node.position = self.position + 32*$RayCast2D.cast_to.normalized()
	pokeball_node.apply_impulse(Vector2(), 600*$RayCast2D.cast_to.normalized())
	pokeball_node.set_angular_velocity(60)
	# aggiungi il nodo pokeball alla scena principale
	get_node("/root/Game").add_child(pokeball_node)
	


func _on_TextBox_dialogue_finished():
	set_process(true)

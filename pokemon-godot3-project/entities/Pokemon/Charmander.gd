extends KinematicBody2D

var stop_probability = 0.3 # 30%
var speed = 160
var movement = Vector2()
var state = "wild"


func _ready():
	randomize()
	$AITimer.start()


func _process(delta):
	if state == "wild":
		if $AITimer.time_left == 0:
			# decidere se Charmander si ferma
			if randf() < stop_probability:
				# Charmander non si muove
				movement = Vector2()
			else:
				movement = get_random_direction()
			
			# se non si ferma, decidere in che direzione va	
			$AITimer.start()
		
		move_and_collide(movement*delta*speed)
		update_animated_sprite(movement)
	elif state == "captured":
		pass


func get_random_direction():
	var rand_direction = Vector2()
	var random_float = randf()
	
	if random_float < 0.25:
		rand_direction.x = -1
	elif random_float >= 0.25 and random_float < 0.5:
		rand_direction.x = 1
	elif random_float >= 0.5 and random_float < 0.75:
		rand_direction.y = 1
	elif random_float >= 0.75 and random_float < 1:
		rand_direction.y = -1
	return rand_direction
	

func update_animated_sprite(velocity):
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


func capture():
	state = "captured"
	$AnimationPlayer.play("flash")

func remove_from_scene():
	queue_free()
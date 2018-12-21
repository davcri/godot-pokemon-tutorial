extends NinePatchRect

signal dialogue_finished

func _ready():
	# disabilita la funzione _process()
	set_process(false)
	# nascondi il TextBox
	hide()

func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		# emetti il signale "dialogue_finished"
		emit_signal("dialogue_finished")
		# nascondi il TextBox
		hide()
		# disabilita la funzione _process()
		set_process(false)
		
func _on_KinematicPlayer2D_dialogue_started(dialogue_text):
	$Label.text = dialogue_text
	# mostra il TextBox
	show()
	# abilita la funzione _process()
	set_process(true)

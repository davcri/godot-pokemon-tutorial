extends CanvasLayer

func _ready():
	pass


func _on_KinematicPlayer2D_pokeball_taken(pokeball_count):
	$Container/TextureRect/Label.text = str(pokeball_count)


func _on_KinematicPlayer2D_pokeball_thrown(pokeball_count):
	$Container/TextureRect/Label.text = str(pokeball_count)

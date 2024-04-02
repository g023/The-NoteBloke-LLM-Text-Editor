extends Button


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready():
	connect("pressed", _on_button_pressed)
	pass

func _on_button_pressed():
	$"../../../../../../FileDialog_save".show()

extends Button



var file_dialog

func _ready():
	# Create a new FileDialog instance
	file_dialog = FileDialog.new()
	# Add the FileDialog as a child of the button
	add_child(file_dialog)
	# Connect signals
	connect("pressed", _on_button_pressed)


func _on_button_pressed():
	$"../../../../../../FileDialog_open".show()


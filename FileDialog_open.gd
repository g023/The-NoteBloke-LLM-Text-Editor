extends FileDialog

var g_last_path = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("file_selected", _on_file_selected)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_file_selected(path):
	print(path)
	g_last_path = path
	print("loading")
	var load_file = FileAccess.open(path, FileAccess.READ)
	#var the_dict = load_file.get_var()
	var the_data = load_file.get_as_text()
	print(the_data)
	$"../HSplitContainer/VBoxContainer_editor/ColorRect/VBoxContainer/TextEdit_main".text = the_data

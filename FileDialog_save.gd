extends FileDialog

var g_last_path

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
	print("save")
	var file = FileAccess.open(path, FileAccess.WRITE)
	var content = $"../HSplitContainer/VBoxContainer_editor/ColorRect/VBoxContainer/TextEdit_main".text
	file.store_string(content)

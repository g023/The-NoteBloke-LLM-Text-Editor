extends Window
#
#var text_edit:TextEdit
#var command_palette:Control
#
## Create a new Timer instance
#var timer = Timer.new()
#
#func _ready():
	##text_edit = TextEdit.new()
	##add_child(text_edit)
##
	##command_palette = Control.new()
	##add_child(command_palette)
	#text_edit = $TextEdit_main
	#command_palette = $Control_main
#
	## Set up rich text support
	##text_edit.bbcode_enabled = true
#
	## Connect signals for text selection and editing
	#text_edit.connect("text_selected", _on_text_selected)
	#text_edit.connect("text_changed", _on_text_changed)
	#text_edit.connect("focus_entered", _on_focus)
	#text_edit.connect("focus_exited", _on_defocus)
	#
#
	## Connect signals for command palette actions
	#command_palette.connect("command1", _on_command1)
	#command_palette.connect("command2", _on_command2)
	#command_palette.connect("command3", _on_command3)
	#
#
	## Add the timer as a child of the current node
	#add_child(timer)
	## Set the timer properties
	## timer.start()
	#timer.wait_time = 2.0 # 500 milliseconds
	## Connect the timer's timeout signal to a function
	#timer.connect("timeout", _on_Timer_timeout)
#
#func _on_Timer_timeout():
	#print("Timer has timed out!")
	## Optionally, restart the timer if it's not set to one-shot
	## timer.start()
#
#
#
#func _on_caret_changed():
	#pass
#
#func _on_focus():
	#print("_on_focus")
	#timer.start()
	#pass
#
#func _on_defocus():
	#print("magnus")
	#timer.stop()
	#pass
#
#
#func _on_text_selected(start: int, end: int):
	## Handle text selection
	## ...
	#print("text selected")
	#pass
	#
#func _on_text_changed():
	## Handle text editing
	## ...
	#print("text changed")
	#pass
#
#func _on_command1():
	## Handle command 1
	## ...
	#pass
	#
#func _on_command2():
	## Handle command 2
	## ...
	#pass
	#
#func _on_command3():
	## Handle command 3
	## ...
	#pass
	#
#func _on_timer():
	#print("hello")
	#pass
#
#
#func _process(float) -> void:
	## Your code here
	##print("tick")
	#pass
#

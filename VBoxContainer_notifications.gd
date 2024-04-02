extends VBoxContainer

@onready var g_notify_template = $Label_notification_template
@onready var g_notify_container = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".show() # force visible
	#pop_msg('hello')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func pop_msg(str_msg):
	var the_node = g_notify_template.duplicate()
	the_node.text = str(str_msg)
	g_notify_container.add_child(the_node)
	the_node.g_active = true
	the_node.show()
	

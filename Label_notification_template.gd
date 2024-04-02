extends Label

# this script is attached to a node that is a notification that shows for a brief duration and then fades away.
# after the message has faded out, we want to remove it from memory

# basically on a timer, which if set (isnt template) will 
# timeout and then remove itself from memory.

# steps:
# 1. create a timer
# 2. set the timer to the duration of the message
# 3. connect the timeout signal to the node's queue_free() function
# 4. when the timer times out, the node will be removed from memory

var g_active = false # we don't want to wipe the template
var g_running = false # 


func _ready():
	pass


func _on_timeout():
	g_running = true
	print('notification:timeout')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if g_running:
		# gradually fade out the message
		modulate.a = modulate.a - 0.01
		if modulate.a <= 0:
			print('notification:removing')
			queue_free()
			
			
	## 
	if g_active:
		g_active = false
		# set a timer to activate the g_running
		var timer = Timer.new()
		timer.set_wait_time(20)
		timer.set_one_shot(true)
		timer.connect("timeout", _on_timeout)
		add_child(timer)
		timer.start()


func _on_button_close_button_up():
	print("button:close")
	g_running = true
	$Button_close.hide()
	pass # Replace with function body.


extends Button


@onready var g_node_use_openai = $"../../../../../../VBoxContainer_editor/ColorRect/VBoxContainer/HBoxContainer/CheckBox_use_openai"
@onready var g_node_openai_key = $"../../../../../../VBoxContainer_editor/ColorRect/VBoxContainer/HBoxContainer/TextEdit_oai_key"
@onready var g_node_max_tokens = $"../../../../../../VBoxContainer_editor/ColorRect/VBoxContainer/HBoxContainer/TextEdit_maxtokens"

@onready var g_node_mem_pre 	= $"../VBoxContainer/HBoxContainer3/TextEdit_mem_pre"
@onready var g_node_mem_post 	= $"../VBoxContainer/HBoxContainer3/TextEdit_mem_post"


@onready var g_node_assistant 	= $"../../VBoxContainer/TextEdit_assistant"
@onready var g_node_prompt 		= $"../../VBoxContainer/TextEdit_prompt"
@onready var g_node_response 	= $"../TextEdit_response"

@onready var g_node_document 	= $"../../../../../../VBoxContainer_editor/ColorRect/VBoxContainer/TextEdit_main"


@onready var g_node_notify = $"../../../../../../../VBoxContainer_notifications"
# g_node_notify.pop_msg(the_msg)

var g_start_time
var g_finish_time

var last_key_down = -1 # used for autocomplete
var last_selected_text = ""
var g_ai_assist_busy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# handle shrinking the pre and post text
func keep_end(text, max_length):
	max_length = int(max_length)
	if max_length < 0:
		max_length = 0

	if text.length() > max_length:
		text = text.substr(text.length()-max_length, max_length)
	return text

func keep_start(text, max_length):
	max_length = int(max_length)
	if max_length < 0:
		max_length = 0

	if text.length() > max_length:
		text = text.substr(0, max_length)
	return text


func _on_button_up():

	
	print("processing message to send")
	
	var selected_text = g_node_document.g_last_selected_text
	var the_pre_str = g_node_document.g_last_selected_pre
	var the_post_str = g_node_document.g_last_selected_post

	var the_last_path = $"../../../../../../../FileDialog_open".g_last_path
	
	var text_assistant = g_node_assistant.text
	var text_prompt = g_node_prompt.text
	var text_document = g_node_document.text

	var ai_memory_pre = int(g_node_mem_pre.text)
	var ai_memory_post = int(g_node_mem_post.text)
	
	var pre = the_pre_str
	var post = the_post_str
	var openai = g_node_use_openai.button_pressed
			
	print("ai assist context menu - intelligent code repair")
	# takes previous content and post content and allows use in final prompt and assistant
	if not g_ai_assist_busy:
		#var selected_text = g_node_document.get_selected_text()
		#var selected_text = g_node_document.my_get_selected()

		var g_node_textedit_main = $"../../../../../../VBoxContainer_editor/ColorRect/VBoxContainer/TextEdit_main"

		var sel 		= g_node_textedit_main.get_selected() # pre, post, selected
		var txt_pre 	= keep_end(sel.pre, ai_memory_pre) 
		var txt_post 	= keep_start(sel.post, ai_memory_post)
		var txt_sel 	= sel.selected
		
		selected_text = txt_sel
		the_pre_str = txt_pre
		the_post_str = txt_post


		print("the_path:", the_last_path)
		print("*-*-*-*")
		print("the_pre:", the_pre_str)
		print("the_post:", the_post_str)
		print("selected text:", selected_text)
		
		if selected_text.strip_edges() == "":
			print("empty input. ignoring.")
		else:
			$".".disabled = true
			g_start_time = Time.get_ticks_usec()			

			g_ai_assist_busy = true # prevent resubmitting
			var the_whole_text = text_document
			var the_selected_text = g_node_document.get_selected_text() #unused
			#var the_pre_text = $".".get_selection_to_line(get_selection_line())
			print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
			print("selected_line:", g_node_document.get_selection_line())
			print("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-")
			
			# if ai_memory_pre < 0:
			# 	ai_memory_pre = 0
			# if ai_memory_post < 0:
			# 	ai_memory_post = 0

			# # only leave the last 500 characters of the pre string
			# if the_pre_str.length() > ai_memory_pre:
			# 	the_pre_str = the_pre_str.substr(the_pre_str.length()-ai_memory_pre, ai_memory_pre)

			# ## NEW: obsolete old:
			# the_pre_str = keep_end(the_pre_str, ai_memory_pre)
			# the_post_str = keep_start(the_post_str, ai_memory_post)
			
			# # only leave the first 500 characters of the post string
			# if the_post_str.length() > ai_memory_post:
			# 	the_post_str = the_post_str.substr(0, ai_memory_post)


			## NEW!
			#the_pre_str = keep_end(the_pre_str, ai_memory_pre)
			#the_post_str = keep_start(the_post_str, ai_memory_post)
			print("*** *** *** *** *** ")
			print("pre:\n", the_pre_str)
			print("*** *** *** *** *** ")
			print("post:\n", the_post_str)
			print("*** *** *** *** *** ")




			var the_assistant = "You are a programming source code optimization expert. You will detect the programming language used and come up with the best code rewrite for the user."
			var the_prompt = "Optimize and enhance the following 'code string': \"" + selected_text + "\"\n\n"
			the_prompt += "The file path is:\n" + the_last_path + "\n\n"
			the_prompt += "A short bit of the part that came before it was:\n" + the_pre_str + "\n\n"
			the_prompt += "A short bit of the part that came after it was:\n" + the_post_str +  "\n\n"

			# we need to pull in new assistant data
			the_assistant = g_node_assistant.text
			the_prompt = g_node_prompt.text
			
			# do some {{{}} replacements
			# replace {{{PRE}}} with the_pre_str
			# replace {{{POST}}} with the_post_str
			# replace {{{SELECTED}}} with selected_text
			# replace {{{PATH}}} with the_last_path
			# replace {{{ASSISTANT}}} with the_assistant
			# replace {{{PROMPT}}} with the_prompt
			var the_replacements = {
				"{{{PRE}}}": the_pre_str,
				"{{{POST}}}": the_post_str,
				"{{{SELECTED}}}": selected_text,
				"{{{FILE_PATH}}}": the_last_path
			}

			# do the replacements
			for key in the_replacements.keys():
				the_assistant = the_assistant.replace(key, the_replacements[key])
				the_prompt = the_prompt.replace(key, the_replacements[key])


			var tokens_max = int(g_node_max_tokens.text)
			
			if tokens_max > 0:
				print("sending request....")
				#llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
				print("THE PROMPT:\n", the_prompt,"\n***\n")
				llm_send_short(the_assistant, the_prompt, tokens_max, 0.0, 0.0, 0.0, rr)
			else:
				print("0 max tokens set")
	else:
		print("assistant busy")
	
	# intelligent code optimizer


	
	# end _on_button_up()










## =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-








### ---




func get_content_inside_backticks(message: String) -> String:
	var start_index = message.find("```")
	if start_index == -1:
		return message
	start_index += 3
	# move to the first \n after the start index
	start_index = message.find("\n", start_index)


	var end_index = message.find("```", start_index)
	if end_index == -1:
		return message

	return message.substr(start_index, end_index - start_index)


# rr = response return
func rr(result, response_code, headers, body):
	
	g_finish_time = Time.get_ticks_usec()
	var elapsed_time = g_finish_time - g_start_time
	var elapsed_time_seconds = elapsed_time / 1000000.0
	print("time taken: ", elapsed_time, "microseconds")
	print("time taken: ", elapsed_time_seconds)
	
	print("---- received response.")
	print("---- body:",body.get_string_from_utf8())
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	var message = response["choices"][0]["message"]["content"]
	print('---- response:', response)
	print(message)
	
	var num_tokens_prompt = response["usage"]["prompt_tokens"]
	var num_tokens_completion = response["usage"]["completion_tokens"]
	var num_tokens_total = response["usage"]["total_tokens"]
	print("prompt tokens:", num_tokens_prompt)
	print("completion tokens:", num_tokens_completion)
	print("total tokens:", num_tokens_total)

	# if message has double quotes on either end, remove them
	if message.begins_with("\"") and message.ends_with("\""):
		message = message.substr(1, message.length()-2)

	#message = get_content_inside_backticks(message)
	print("message:\n", message)


	# if message has ``` triple backticks, only return content inside them
	

	# Pop up notification
	var the_msg = ""
	the_msg += "time: " + str(elapsed_time_seconds) + " seconds, "
	the_msg += "prompt tokens: " + str(num_tokens_prompt) + ", "
	the_msg += "completion tokens: " + str(num_tokens_completion) + ", "
	the_msg += "total tokens: " + str(num_tokens_total) + ", "
	the_msg += "tps: " + str(num_tokens_total / elapsed_time_seconds) + ""
	g_node_notify.pop_msg(the_msg)

	$".".disabled = false
	
	#$".".text += message
	g_node_response.text = message
	g_ai_assist_busy = false
	
	# END - replace selected text
	
	
	
	
	
### end -- ai assistant -- selected text cleanup
### end -- ai assistant -- selected text cleanup
### end -- ai assistant -- selected text cleanup


# END # CONTEXT MENU


func _unhandled_input(event):
	if event is InputEventKey:
		# print("key down")
		last_key_down = Time.get_unix_time_from_system()
		# now we put autocomplete in here and cast generation to local llm when we stop typing?
		# make in a new scene so we don't pollute this one. Maybe its own standalone copilot thingy.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# check time against last_key down to determine if it is time to autocomplete.
	if last_key_down != -1 and last_key_down + 3 < Time.get_unix_time_from_system():
		last_key_down = -1
		print("init autocomplete")
		timed_autocomplete()
	pass
	
func timed_autocomplete():
	print("do_autocomplete()")
	
	# example selected modify for rewriting ai buddy
	#var selected_text = $"../../VBoxContainer2/TextEdit_LLM_INPUT".get_selected_text()
	#$"../../VBoxContainer2/TextEdit_LLM_INPUT".delete_selection()
	#$"../../VBoxContainer2/TextEdit_LLM_INPUT".insert_text_at_caret ( "xxxxx" )
	#print("LLM_INPUT:", selected_text)
	
	# self.text += " asdasdasd"
	# Get the length of the text in the TextEdit node
	# var text_length = self.get_text().length()

	# Set the cursor position to the end of the text

	pass


func do_ai_assist():
	
	pass

func _on_autocomplete(prefix):
	print("prefix:", prefix)
	# return filter(lambda w: w.begins_with(prefix), suggestions)


##### BEGIN CRITICAL ####


func llm_get_headers(openai=false):
	var openai_key = g_node_openai_key.text
			
	var headers = []
	
	if openai:
		var api_key = openai_key
		headers = ["Content-type: application/json", "Authorization: Bearer " + api_key]
	else:
		headers = ["Content-type: application/json"]
		print(headers)
	return headers



func llm_get_body_short(the_messages, max_tokens, temperature, frequency_penalty, presence_penalty):
	var model = "gpt-3.5-turbo-16k"
	max_tokens 			= int(max_tokens)
	temperature 		= float(temperature)
	frequency_penalty 	= float(frequency_penalty)
	presence_penalty	= float(presence_penalty)

	# prepend assistant prompt only for the output
	var send_messages 	= the_messages


	var openai = g_node_use_openai.button_pressed
	
	var body = ""
	
	# get api key
	if openai:				
		body = JSON.new().stringify({
			"messages": send_messages,
			"temperature": temperature,
			"frequency_penalty": frequency_penalty,
			"presence_penalty": presence_penalty,
			"max_tokens": max_tokens,
			"model":model, 
			"stream":false
		})
	else: # local llm
		body = JSON.new().stringify({
			"messages": send_messages,
			"temperature": temperature,
			"frequency_penalty": frequency_penalty,
			"presence_penalty": presence_penalty,
			"max_tokens": max_tokens,
			# "model":"", 
			"stream":false
		})	
	
	print("body:", body)
	return body


func llm_send_request_short(url, headers, body, return_func):
	print("sending request")
	#$HTTPRequest.request_completed.connect(llm_response_return)
	$HTTPRequest.request_completed.connect(return_func)
	var send_request = $HTTPRequest.request(url,headers,HTTPClient.METHOD_POST, body) # what do we want to connect to

	if send_request != OK:
		print("ERROR sending request")
	pass



func llm_send_short(assistant, prompt, max_tokens, temperature, frequency_penalty, presence_penalty, return_Func):

	## --- begin local or remote
	var openai = g_node_use_openai.button_pressed
	
	# get api key
	if openai:
		var api_key = g_node_openai_key.text
	




	var url 	= llm_get_url(openai)
	var headers = llm_get_headers(openai)
	## --- end local or remote

	var msgs = []
	msgs.append({
		"role":"assistant",
		"content":assistant
	})

	msgs.append({
		"role":"user", # user
		"content":prompt
	})
	
	var the_body = llm_get_body_short(msgs, max_tokens, temperature, frequency_penalty, presence_penalty)
	# send url
	llm_send_request_short(url, headers, the_body, return_Func)

	pass


func llm_get_url(openai=false):
	var the_url = "http://localhost:1234/v1/chat/completions"

	if openai:
		the_url = "https://api.openai.com/v1/chat/completions"
		
	return the_url

#### END CRITICAL FUNCTIONS ####








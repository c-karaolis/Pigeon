extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var url_box = $UrlText
onready var body_text_box = $BodyText
onready var result_text_box = $ResultText
onready var headers_text_box = $HeadersText
onready var post_request = $PostHTTPRequest
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PostHTTPRequest_request_completed(result, response_code, headers, body):
#	var json = JSON.parse(body.get_string_from_utf8())
#	print(result)
#	print(body.get_string_from_utf8())
#	print(json.result)
#	print(json.error)
#	print(json.error_string)
#	var texter = json.error if json.error != OK else json.result
	result_text_box.text = body.get_string_from_utf8()
	pass # Replace with function body.


func _on_GetHTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.


func _on_PutHTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.


func _on_PostButton_button_up():
	var body_text = body_text_box.text
	var headers = headers_text_box.split("|")
#	var headers = ["Content-Type: application/json; charset=UTF-8"]
	body_text = remove_json_trailing_artifacts(body_text)
	post_request.request(url_box.text, headers, false, HTTPClient.METHOD_POST, body_text)
	pass # Replace with function body.


func remove_json_trailing_artifacts(json: String):
	if json[json.length() -2] != '"':
		json.erase(json.length() -2 , 1)
		json = remove_json_trailing_artifacts(json)
		return json
	else:
		return json
	

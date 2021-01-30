extends Control

onready var url_box: TextEdit  = $UrlText
onready var body_text_box: TextEdit = $BodyText
onready var result_text_box: TextEdit = $ResultText
onready var headers_text_box: TextEdit = $HeadersText
onready var post_request: HTTPRequest = $PostHTTPRequest

func _ready():
	pass # Replace with function body.


func _on_PostHTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
#	var json = JSON.parse(body.get_string_from_utf8())
#	var texter = json.error if json.error != OK else json.result
	result_text_box.text = body.get_string_from_utf8()
	pass # Replace with function body.


func _on_GetHTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	pass


func _on_PutHTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	pass 


func _on_PostButton_button_up():
	var body_text: String = body_text_box.text
	var headers: Array = headers_text_box.text.split("|")
	set_result_requesting_text()
	print (headers)
#	var headers = ["Content-Type: application/json; charset=UTF-8"]
	body_text = remove_json_trailing_artifacts(body_text)
	post_request.request(url_box.text, headers, false, HTTPClient.METHOD_POST, body_text)
	pass 


func remove_json_trailing_artifacts(json: String):
	if json[json.length() -2] != '"':
		json.erase(json.length() -2 , 1)
		json = remove_json_trailing_artifacts(json)
		return json
	else:
		return json
	


func set_result_requesting_text():
	result_text_box.text = "Requesting . . ."

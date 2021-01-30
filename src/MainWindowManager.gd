extends Control

onready var url_box: TextEdit  = $UrlText
onready var body_text_box: TextEdit = $BodyText
onready var result_text_box: TextEdit = $ResultText
onready var headers_text_box: TextEdit = $HeadersText
onready var post_request: HTTPRequest = $PostHTTPRequest
onready var get_request: HTTPRequest = $GetHTTPRequest
onready var put_request: HTTPRequest = $PutHTTPRequest


func _on_PostHTTPRequest_request_completed(_result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
#	var json = JSON.parse(body.get_string_from_utf8())
#	var texter = json.error if json.error != OK else json.result
	result_text_box.text = _body.get_string_from_utf8()


func _on_GetHTTPRequest_request_completed(_result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
	result_text_box.text = _body.get_string_from_utf8()


func _on_PutHTTPRequest_request_completed(_result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
	result_text_box.text = _body.get_string_from_utf8() 


func _on_PostButton_button_up() -> void:
	var _input_values: Dictionary = get_refreshed_textbox_values()
	var body_text: String = _input_values.RequestBody
	set_result_requesting_text()
#	var headers = ["Content-Type: application/json; charset=UTF-8"]
	body_text = remove_json_trailing_artifacts(body_text)
	post_request.request(_input_values.URL, _input_values.Headers, false, HTTPClient.METHOD_POST, body_text)


func _on_GetButton_button_up() -> void:
	var _input_values: Dictionary = get_refreshed_textbox_values()
	get_request.request(_input_values.URL, _input_values.Headers)
	set_result_requesting_text()


func _on_PutButton_button_up() -> void:
	var _input_values: Dictionary = get_refreshed_textbox_values()
#	set_result_requesting_text()
	pass # Replace with function body.


func remove_json_trailing_artifacts(json: String) -> String:
	if json[json.length() -2] != '"':
		json.erase(json.length() -2 , 1)
		json = remove_json_trailing_artifacts(json)
		return json
	else:
		return json


func get_refreshed_textbox_values() -> Dictionary:
	var _url: String = url_box.text
	var _headersRaw: String = headers_text_box.text
	var _headers: Array = _headersRaw.split("|")
	var _bodyRaw: String = body_text_box.text
	var _returnValues: Dictionary = {
		"URL":_url,
		"Headers":_headers,
		"RequestBody":_bodyRaw
	}
	return _returnValues


func set_result_requesting_text() -> void:
	result_text_box.text = "Requesting . . ."


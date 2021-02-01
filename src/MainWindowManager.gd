extends Control


onready var url_box: TextEdit  = $UrlText
onready var body_text_box: TextEdit = $BodyText
onready var result_text_box: TextEdit = $ResultText
onready var headers_text_box: TextEdit = $HeadersText
onready var post_request: HTTPRequest = $PostHTTPRequest
onready var get_request: HTTPRequest = $GetHTTPRequest
onready var put_request: HTTPRequest = $PutHTTPRequest
onready var validation_label: Label = $Labels/ValidationLabel


func _on_PostHTTPRequest_request_completed(_result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
	result_text_box.text = _body.get_string_from_utf8()


func _on_GetHTTPRequest_request_completed(_result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
	result_text_box.text = _body.get_string_from_utf8()


func _on_PutHTTPRequest_request_completed(_result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
	result_text_box.text = _body.get_string_from_utf8() 


func _on_PostButton_button_up() -> void:
	var _input_values: Dictionary = get_refreshed_textbox_values()
	post_request.request(_input_values.URL, _input_values.Headers, false, HTTPClient.METHOD_POST, _input_values.RequestBody)


func _on_GetButton_button_up() -> void:
	var _input_values: Dictionary = get_refreshed_textbox_values()
	get_request.request(_input_values.URL, _input_values.Headers)


func _on_PutButton_button_up() -> void:
	var _input_values: Dictionary = get_refreshed_textbox_values()
	put_request.request(_input_values.URL, _input_values.Headers, false, HTTPClient.METHOD_PUT, _input_values.RequestBody)


func _on_ValidateJSONButton_button_up() -> void:
	body_text_box.text = validate_and_beautify_json(body_text_box.text)


func remove_json_trailing_artifacts(_json: String) -> String:
	if _json[_json.length() -2] != '"':
		_json.erase(_json.length() -2 , 1)
		_json = remove_json_trailing_artifacts(_json)
	return _json


func remove_url_trailing_artifacts(_url: String) -> String:
	if _url[_url.length() -1] == ' ':
		_url.erase(_url.length() -1 , 1)
		_url = remove_url_trailing_artifacts(_url)
	return _url


func validate_and_beautify_json(_json: String) -> String:
	var _json_parsed: JSONParseResult = JSON.parse(_json)
	if _json_parsed.error != OK:
		validation_label.add_color_override("font_color", Color(1,0,0,1))
		validation_label.text = "Invalid JSON format."
		return _json
	validation_label.add_color_override("font_color", Color(0,1,0,1))
	validation_label.text = "Valid JSON format."
	_json = JSON.print(_json_parsed.result, "\t")
	return _json


func get_refreshed_textbox_values() -> Dictionary:
	result_text_box.text = "Requesting . . ."
	print(validate_and_beautify_json(body_text_box.text))
	body_text_box.text = validate_and_beautify_json(body_text_box.text)
	var _url: String = remove_url_trailing_artifacts(url_box.text)
	var _headersRaw: String = headers_text_box.text
	var _headers: Array = _headersRaw.split("|")
	var _body: String = remove_json_trailing_artifacts(body_text_box.text)
	var _returnValues: Dictionary = {
		"URL":_url,
		"Headers":_headers,
		"RequestBody":_body
	}
	return _returnValues
	

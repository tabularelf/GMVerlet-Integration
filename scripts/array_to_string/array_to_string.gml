// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function array_to_string(_array){
	var _len = array_length(_array);
	var _str = "[";
	
	for(var _i = 0; _i < _len; ++_i) {
		if (_i != 0) {
			_str += ", ";
		}
		
		_str += string(_array[_i]);
	}
	_str += "]"
	
	return _str;
}
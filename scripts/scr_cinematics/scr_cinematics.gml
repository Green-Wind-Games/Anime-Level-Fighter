/*

function start_cinematic(_attacker, _defender, _sequence) {
	var _layer = "Instances";
	
	var _sequence_id = layer_sequence_create(_layer, _attacker.x, _attacker.y, _sequence);
	var _sequence_instance = layer_sequence_get_instance(_sequence_id);
	
	sequence_instance_override_object(_sequence_instance,obj_cinematic_attacker,_attacker);
	sequence_instance_override_object(_sequence_instance,obj_cinematic_defender,_defender);
}
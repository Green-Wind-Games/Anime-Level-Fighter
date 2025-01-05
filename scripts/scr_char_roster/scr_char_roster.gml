enum universes {
	dragonball,
	narutoshippuden,
	jojos,
	
	onepunchman,
	onepiece,
	nanatsu,
	bleach,
	
	uniforce,
	
	alluniverses
}

globalvar	char_list, max_characters,
			chars_per_row, chars_per_column, chars_per_universe;

char_list = array_create(0);

chars_per_universe = 8;

max_characters = chars_per_universe * universes.alluniverses;

chars_per_row = chars_per_universe;
chars_per_column = ceil(max_characters / chars_per_row);

function char(_name) constructor {
	name = _name;
	_name = string_lower(_name);
	object = asset_get_index("obj_" + _name);
	sprite = asset_get_index("spr_" + _name + "_idle");
	portrait = asset_get_index("spr_" + _name + "_portrait");
	icon = asset_get_index("spr_" + _name + "_icon");
}

function add_char(_name) {
	var newchar = new char(_name);
	array_push(char_list,newchar);
	//max_characters++;

	//chars_per_row = clamp(max_characters, 1, chars_per_universe);
	//chars_per_column = ceil(max_characters / chars_per_row);
}

function add_char_multiple(_chars) {
	for(var i = 0; i < array_length(_chars); i++) {
		add_char(_chars[i]);
	}
}

add_char_multiple(
	[
		"Goku", "Vegeta", "Trunks", "Piccolo",
		"Freeza", "Cell", "Broly", "Buu",
		
		"Naruto", "Sasuke", "Sakura", "Kakashi",
		"Orochimaru", "Itachi", "Pain", "Madara",
		
		"Jotaro", "Giorno", "Joseph", "Kakyoin",
		"Dio", "Kars", "Diavolo", "Kira",
		
		"Tanjiro", "Nezuko", "Inosuke", "Zenitsu",
		"Muzan", "Rui", "Akaza", "Doma",
		
		"Enker", "Derek", "Linda", "Angelo",
		"Erika", "Diana", "Azuri", "Gabriel",
		
		"Saitama", "Genos", "Luffy", "Zoro",
		"Meliodas", "Ban", "Ichigo", "Aizen",
	]
);

repeat(max_characters-array_length(char_list)) {
	add_char("");
}
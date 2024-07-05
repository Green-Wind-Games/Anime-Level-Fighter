globalvar	chars_per_column, chars_per_row,
			charselect_icon, charselect_obj, charselect_portrait, charselect_name, charselect_assist,
			max_characters, max_team_size,
			
			p1_charselect_state, p2_charselect_state, p1_charselect_id, p2_charselect_id,
			p1_selecting_char, p1_selecting_form, p1_selecting_assist,
			p2_selecting_char, p2_selecting_form, p2_selecting_assist,
			p1_selected_char, p1_selected_form, p1_selected_assist,
			p2_selected_char, p2_selected_form, p2_selected_assist;;

enum chars {
	enker,
	linda,
	derek,
	erika,
	diana,
	azuri,
	
	john,
	klence,
	oriel,
	dan,
	ethan,
	mei,
	
	ioberon,
	roberto,
	frosent,
	watts,
	axter,
	fenix,
	
	warrior,
	archer,
	mage,
	necromancer,
	shaman,
	spiritualist,
	
	dysha,
	jernhjerte,
	fargus,
	thoradin,
	malenia,
	flora,
	
	allchars
}

enum charselectstates {
	off,
	char,
	form,
	assist,
	finished
}

max_characters = chars.allchars;
max_team_size = 1;

p1_charselect_id = 0;
p1_charselect_state = charselectstates.char;
p1_selecting_char = 0;
p1_selecting_form = 0;
p1_selecting_assist = assist_type.a;

p2_charselect_id = 0;
p2_charselect_state = charselectstates.char;
p2_selecting_char = 0;
p2_selecting_form = 0;
p2_selecting_assist = assist_type.a;

for(var i = 0; i < max_team_size; i++) {
	p1_selected_char[i] = 0;
	p1_selected_form[i] = 0;
	p1_selected_assist[i] = assist_type.a;
	
	p2_selected_char[i] = 0;
	p2_selected_form[i] = 0;
	p2_selected_assist[i] = assist_type.a;
}

chars_per_row = 6;
chars_per_column = ceil(max_characters / chars_per_row);

for(var i = 0; i < chars_per_row * chars_per_column; i++) {
	charselect_obj[i][0] = noone;
	charselect_portrait[i][0] = noone;
	charselect_icon[i] = noone;
	charselect_name[i] = "";
}

charselect_icon[chars.enker] = spr_enker_icon;
charselect_obj[chars.enker][0] = obj_enker;
charselect_portrait[chars.enker][0] = spr_enker_portrait;
charselect_name[chars.enker] = "Enker";
charselect_assist[chars.enker][0][assist_type.a] = "Badugi";
charselect_assist[chars.enker][0][assist_type.b] = "Corte Giratório";
charselect_assist[chars.enker][0][assist_type.c] = "Rajada Verde";
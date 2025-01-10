/// @description Insert description here
// You can write your code in this editor

max_hp = base_max_hp;
hp = max_hp;
previous_hp = hp;
dead = false;

mp = 0;
mp_stocks = 0;

tp = max_tp;
tp_stocks = max_tp_stocks;

level = 1;
max_xp = base_max_xp;
xp = 0;

hp_percent = (hp / max_hp) * 100;
mp_percent = (mp / max_mp) * 100;
tp_percent = (tp / max_tp) * 100;
xp_percent = (xp / max_xp) * 100;
dmg_percent = 0;

hp_percent_visible = hp_percent;
mp_percent_visible = mp_percent;
tp_percent_visible = tp_percent;
xp_percent_visible = xp_percent;
dmg_percent_visible = dmg_percent;

team = id;
target = noone;
target_x = 0;
target_y = 0;
target_distance = 0;
target_distance_x = 0;
target_distance_y = 0;
target_direction = 0;

hurtbox = noone;
hitbox = noone;

mask_index = spr_charbox;

hitstun = 0;
blockstun = 0;
hitstop = 0;

is_hit = false;

is_guarding = false;
can_guard = true;

grabbed = noone;
grab_connect_state = noone;

combo_timer = 0;
combo_hits = 0;
combo_hits_taken = 0;
combo_hits_counter = 0;
combo_hits_visible = 0;
combo_damage = 0;
combo_damage_taken = 0;
combo_damage_counter = 0;
combo_damage_visible = 0;
combo_damage_scaling = 1;

invincible = false;
dodging_attacks = false;
deflecting_attacks = false;

immune_to_projectiles = false;
dodging_projectiles = false;
deflecting_projectiles = false;

input = noone;
input_buffer = "";
input_buffer_timer = 0;
	
ground_movelist[0][0] = noone;
air_movelist[0][0] = noone;
cancelable_moves = ds_list_create();
can_cancel = true;

attack_hits = 0;

special_state = noone;
super_state = noone;
ultimate_state = noone;
	
special_active = false;
super_active = false;
ultimate_active = false;

beam = noone;

air_moves = 0;
max_air_moves = 1;

ygravity_mod = 1;

attack_power = 1;
defense = 1;

next_form = noone;
transform_aura = spr_aura_dbz_white;
	
aura_sprite = noone;
aura_frame = 0;

charge_aura = spr_aura_dbz_white;
charge_start_sound = snd_energy_start;
charge_loop_sound = snd_energy_loop;
charge_stop_sound = snd_energy_stop;

char_script = function() {};

death_script = function() {};
death_timer = 0;

draw_script = function() {};

char_id = noone;
name = "ERROR";
form_name = "base";
display_name = "ERROR";
form_display_name = "ERROR";
universe = noone;

theme = noone;
theme_pitch = 1;

init_physics();
init_charsprites("goku");
init_charstates();
init_charaudio();

ai_enabled = false;
ai_timer = 0;
ai_script = function() {};

owner = noone;
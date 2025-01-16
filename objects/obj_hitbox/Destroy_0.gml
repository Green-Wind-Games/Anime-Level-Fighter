if instance_exists(owner) {
	if is_char(owner) {
		if ds_list_empty(hit_list) {
			with(owner) {
				attack_whiff_script(target);
				with(target) {
					if target == other {
						defense_whiff_script(other);
					}
				}
			}
		}
	}
}
if (character == 0) || (character == 1) || (character == 2) || (character == 3) || (character == 4) || (character == 5) {
	characterDefeated = oMarioDefeated;
	if (type = 0) {
		if (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_mWalk;
		}
		else if (isBoot = 1) && (isRiding = 0) {
			sprite_index = spr_mBootWalk;
		}
		else if (isRiding = 1) && (isBoot = 0) {
			sprite_index = spr_mYoshiWalk;
		}
		else if ((isRiding = 1) && (isBoot = 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random = 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random = 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type = 1) {
		if (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_smWalk;
		}
		else if (isBoot = 1) && (isRiding = 0) {
			sprite_index = spr_smBootWalk;
		}
		else if (isRiding = 1) && (isBoot = 0) {
			sprite_index = spr_smYoshiWalk;
		}
		else if ((isRiding = 1) && (isBoot = 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random = 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random = 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type = 2) {
		if (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_fmWalk;
		}
		else if (isBoot = 1) && (isRiding = 0) {
			sprite_index = spr_fmBootWalk;
		}
		else if (isRiding = 1) && (isBoot = 0) {
			sprite_index = spr_fmYoshiWalk;
		}
		else if ((isRiding = 1) && (isBoot = 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random = 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random = 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
}
// Mario
if (character == 0) || (character == 1) || (character == 2) || (character == 3) || (character == 4) || (character == 5) {
	characterDefeated = oMarioDefeated;
	if (type == 0) {
		if (isBoot == 0) && (isRiding == 0) {
			sprite_index = spr_mWalk;
		}
		else if (isBoot == 1) && (isRiding == 0) {
			sprite_index = spr_mBootWalk;
		}
		else if (isRiding == 1) && (isBoot == 0) {
			sprite_index = spr_mYoshiWalk;
		}
		else if ((isRiding == 1) && (isBoot == 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random == 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random == 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type == 1) {
		if (isBoot == 0) && (isRiding == 0) {
			sprite_index = spr_smWalk;
		}
		else if (isBoot == 1) && (isRiding == 0) {
			sprite_index = spr_smBootWalk;
		}
		else if (isRiding == 1) && (isBoot == 0) {
			sprite_index = spr_smYoshiWalk;
		}
		else if ((isRiding == 1) && (isBoot == 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random == 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random == 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type == 2) {
		if (isBoot == 0) && (isRiding == 0) {
			sprite_index = spr_fmWalk;
		}
		else if (isBoot == 1) && (isRiding == 0) {
			sprite_index = spr_fmBootWalk;
		}
		else if (isRiding == 1) && (isBoot == 0) {
			sprite_index = spr_fmYoshiWalk;
		}
		else if ((isRiding == 1) && (isBoot == 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random == 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random == 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
}
// Luigi
if (character == 6) || (character == 7) || (character == 8) || (character == 9) {
	characterDefeated = oLuigiDefeated;
	if (type == 0) {
		if (isBoot == 0) && (isRiding == 0) {
			sprite_index = spr_lWalk;
		}
		else if (isBoot == 1) && (isRiding == 0) {
			sprite_index = spr_lBootWalk;
		}
		else if (isRiding == 1) && (isBoot == 0) {
			sprite_index = spr_lYoshiWalk;
		}
		else if ((isRiding == 1) && (isBoot == 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random == 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random == 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type == 1) {
		if (isBoot == 0) && (isRiding == 0) {
			sprite_index = spr_slWalk;
		}
		else if (isBoot == 1) && (isRiding == 0) {
			sprite_index = spr_slBootWalk;
		}
		else if (isRiding == 1) && (isBoot == 0) {
			sprite_index = spr_slYoshiWalk;
		}
		else if ((isRiding == 1) && (isBoot == 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random == 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random == 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type == 2) {
		if (isBoot == 0) && (isRiding == 0) {
			sprite_index = spr_flWalk;
		}
		else if (isBoot == 1) && (isRiding == 0) {
			sprite_index = spr_flBootWalk;
		}
		else if (isRiding == 1) && (isBoot == 0) {
			sprite_index = spr_flYoshiWalk;
		}
		else if ((isRiding == 1) && (isBoot == 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random == 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random == 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
}
// Luigi
if (character == 10) || (character == 11) || (character == 12) {
	characterDefeated = oToadDefeated;
	if (type == 0) {
		if (isBoot == 0) && (isRiding == 0) {
			sprite_index = spr_tWalk;
		}
		else if (isBoot == 1) && (isRiding == 0) {
			sprite_index = spr_tBootWalk;
		}
		else if (isRiding == 1) && (isBoot == 0) {
			sprite_index = spr_tYoshiWalk;
		}
		else if ((isRiding == 1) && (isBoot == 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random == 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random == 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type == 1) {
		if (isBoot == 0) && (isRiding == 0) {
			sprite_index = spr_stWalk;
		}
		else if (isBoot == 1) && (isRiding == 0) {
			sprite_index = spr_stBootWalk;
		}
		else if (isRiding == 1) && (isBoot == 0) {
			sprite_index = spr_stYoshiWalk;
		}
		else if ((isRiding == 1) && (isBoot == 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random == 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random == 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type == 2) {
		if (isBoot == 0) && (isRiding == 0) {
			sprite_index = spr_ftWalk;
		}
		else if (isBoot == 1) && (isRiding == 0) {
			sprite_index = spr_ftBootWalk;
		}
		else if (isRiding == 1) && (isBoot == 0) {
			sprite_index = spr_ftYoshiWalk;
		}
		else if ((isRiding == 1) && (isBoot == 1)) {
			choose_random = irandom_range(0,1) {
				if (choose_random == 0) {
					isRiding = 1;
					isBoot = 0;
				}
					if (choose_random == 1) {
					isRiding = 0;
					isBoot = 1;
				}
				sc_determineCharacter();
			}
		}
	}
}
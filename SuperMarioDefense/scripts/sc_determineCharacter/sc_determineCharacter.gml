if (character == 0) || (character == 1) || (character == 2) || (character == 3) || (character == 4) || (character == 5) {
	characterDefeated = oMarioDefeated;
	if (type = 0) {
		if (isHoldingBaby = 0) && (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_smwalk;
		}
		else if (isHoldingBaby = 1) && (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_smcarry;
		}
		else if (isBoot = 1) && (isHoldingBaby = 0) && (isRiding = 0) {
			sprite_index = spr_smboot;
		}
		else if (isRiding = 1) && (isBoot = 0) && (isHoldingBaby = 0) {
			sprite_index = spr_smride;
		}
		else if (isRiding = 1) && (isBoot = 1) || (isRiding = 1) && (isHoldingBaby = 1) || (isBoot = 1) && (isHoldingBaby = 1) || (isRiding = 1) && (isBoot = 1) && (isHoldingBaby = 1) {
			choose_random = irandom_range(0,2) {
				if (choose_random = 0) {
					isRiding = 1;
					isBoot = 0;
					isHoldingBaby = 0;
				}
					if (choose_random = 1) {
					isRiding = 0;
					isBoot = 1;
					isHoldingBaby = 0;
				}
					if (choose_random = 2) {
					isRiding = 0;
					isBoot = 0;
					isHoldingBaby = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type = 1) {
		if (isHoldingBaby = 0) && (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_bmwalk;
		}
		else if (isHoldingBaby = 1) && (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_bmcarry;
		}
		else if (isBoot = 1) && (isHoldingBaby = 0) && (isRiding = 0) {
			sprite_index = spr_bmboot;
		}
		else if (isRiding = 1) && (isBoot = 0) && (isHoldingBaby = 0) {
			sprite_index = spr_bmride;
		}
		else if (isRiding = 1) && (isBoot = 1) || (isRiding = 1) && (isHoldingBaby = 1) || (isBoot = 1) && (isHoldingBaby = 1) || (isRiding = 1) && (isBoot = 1) && (isHoldingBaby = 1) {
			choose_random = irandom_range(0,2) {
				if (choose_random = 0) {
					isRiding = 1;
					isBoot = 0;
					isHoldingBaby = 0;
				}
					if (choose_random = 1) {
					isRiding = 0;
					isBoot = 1;
					isHoldingBaby = 0;
				}
					if (choose_random = 2) {
					isRiding = 0;
					isBoot = 0;
					isHoldingBaby = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type = 2) {
		if (isHoldingBaby = 0) && (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_fmwalk;
		}
		else if (isHoldingBaby = 1) && (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_fmcarry;
		}
		else if (isBoot = 1) && (isHoldingBaby = 0) && (isRiding = 0) {
			sprite_index = spr_fmboot;
		}
		else if (isRiding = 1) && (isBoot = 0) && (isHoldingBaby = 0) {
			sprite_index = spr_fmride;
		}
		else if (isRiding = 1) && (isBoot = 1) || (isRiding = 1) && (isHoldingBaby = 1) || (isBoot = 1) && (isHoldingBaby = 1) || (isRiding = 1) && (isBoot = 1) && (isHoldingBaby = 1) {
			choose_random = irandom_range(0,2) {
				if (choose_random = 0) {
					isRiding = 1;
					isBoot = 0;
					isHoldingBaby = 0;
				}
					if (choose_random = 1) {
					isRiding = 0;
					isBoot = 1;
					isHoldingBaby = 0;
				}
					if (choose_random = 2) {
					isRiding = 0;
					isBoot = 0;
					isHoldingBaby = 1;
				}
				sc_determineCharacter();
			}
		}
	}
	if (type = 3) {
		if (isHoldingBaby = 0) && (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_bmwalk;
		}
		else if (isHoldingBaby = 1) && (isBoot = 0) && (isRiding = 0) {
			sprite_index = spr_bmcarry;
		}
		else if (isBoot = 1) && (isHoldingBaby = 0) && (isRiding = 0) {
			sprite_index = spr_bmboot;
		}
		else if (isRiding = 1) && (isBoot = 0) && (isHoldingBaby = 0) {
			sprite_index = spr_bmride;
		}
		else if (isRiding = 1) && (isBoot = 1) || (isRiding = 1) && (isHoldingBaby = 1) || (isBoot = 1) && (isHoldingBaby = 1) || (isRiding = 1) && (isBoot = 1) && (isHoldingBaby = 1) {
			choose_random = irandom_range(0,2) {
				if (choose_random = 0) {
					isRiding = 1;
					isBoot = 0;
					isHoldingBaby = 0;
				}
					if (choose_random = 1) {
					isRiding = 0;
					isBoot = 1;
					isHoldingBaby = 0;
				}
					if (choose_random = 2) {
					isRiding = 0;
					isBoot = 0;
					isHoldingBaby = 1;
				}
				sc_determineCharacter();
			}
		}
	}
}

if (character == 6) || (character == 7) || (character == 8) || (character == 9) || (character == 10) {
	characterDefeated = oLuigiDefeated;
	sprite_index = spr_slwalk;
}

if (character == 11) || (character == 12) {
	characterDefeated = oToadDefeated;
	sprite_index = spr_stwalk;
}
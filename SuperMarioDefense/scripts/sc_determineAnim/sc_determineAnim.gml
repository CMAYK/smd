if (character = 0) {
	if (type = 0) {
		if (isHoldingBaby = 0){
			if (isBoot = 0){
				if (isRiding = 0){sprite_index = spr_smwalk;}
				else{sprite_index = spr_smride;}
			}
			else{sprite_index = spr_smboot;}
		}
		else{sprite_index = spr_smcarry;}
	}
	else if (type = 1)
	{
		if (isHoldingBaby = 0){
			if (isBoot = 0){
				if (isRiding = 0){sprite_index = spr_bmwalk;}
				else{sprite_index = spr_bmride;}
			}
			else{sprite_index = spr_bmboot;}
		}
		else{sprite_index = spr_bmcarry;}
	}
}
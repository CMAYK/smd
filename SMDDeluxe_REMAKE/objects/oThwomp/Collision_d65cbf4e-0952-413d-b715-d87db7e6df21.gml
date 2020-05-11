if (canDamage) {
	if (other.enemyHit = true) exit;
	other.enemyHit = true;
	other.alarm[0] = 40;
	other.enemyHealth -= thwompLevel;
	if !(countdown) {
		alarm[2] = 10;
		countdown = true;
	}
}
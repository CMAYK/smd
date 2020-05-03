if (instance_exists(oEnemy)) {
	nearEnemy = instance_nearest(x, y, oEnemy);
	if (nearEnemy.x > x - 150) {
		drawWarning = true;		
	}
	else {
		drawWarning = false;	
	}
}
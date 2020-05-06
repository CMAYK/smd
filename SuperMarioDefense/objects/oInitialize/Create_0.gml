/// @desc
sc_musicCreate()
sc_createHUDObjects()

shopPage = 0;
shopDescription = 0;

global.coins = 0;

//enemySpawnHealth = 2;

timer_var = 0;
clockSeconds = 0;
clockHandAngle = 0;
clockHandRevolutions = 0;

if (oEnemySpawner.level = 1) {
	global.waves = 15;
}

randomize();
instance_create_layer(240, 180, "Instances", oCamera);

global.livescounter = 10;
if (global.livescounter == 10){
	o = instance_create_layer(1302, 216, "Instances", oLife);
	o.life = 0
	o = instance_create_layer(1321, 213, "Instances", oLife);
	o.life = 1
	o = instance_create_layer(1341, 211, "Instances", oLife);
	o.life = 2
	o = instance_create_layer(1361, 207, "Instances", oLife);
	o.life = 3
	o = instance_create_layer(1381, 206, "Instances", oLife);
	o.life = 4
	o = instance_create_layer(1400, 206, "Instances", oLife);
	o.life = 5
	o = instance_create_layer(1420, 207, "Instances", oLife);
	o.life = 6
	o = instance_create_layer(1440, 211, "Instances", oLife);
	o.life = 7
	o = instance_create_layer(1460, 213, "Instances", oLife);
	o.life = 8
	o = instance_create_layer(1480, 216, "Instances", oLife);
	o.life = 9
}


global.SMW = font_add_sprite_ext(spr_font, "0123456789abcdefghijklmnopqrstuvwxyz.:,*-!", true, 2);
/// @desc oInitialize
// Set Screen
defaultW = 533
defaultH = 300
window_set_size(defaultW*2, defaultH*2);

// Import Scripts
sc_musicCreate()

// Create Important Objects
instance_create_layer(x, y, "Instances", oBack);
instance_create_layer(x, y, "Instances", oCamera);
instance_create_layer(x, y, "Instances", oHUDSelectL);
instance_create_layer(x, y, "Instances", oHUDSelectR);
instance_create_layer(x+1400, y+261, "Instances", oCastle);
instance_create_layer(x+1400, y+261, "Instances", oCastleDoor);
global.playerLives = 10;
if (global.playerLives == 10){
	o = instance_create_layer(x+1302, y+116, "Instances", oLife);
	o.display = 0
	o = instance_create_layer(x+1321, y+113, "Instances", oLife);
	o.display = 1
	o = instance_create_layer(x+1341, y+111, "Instances", oLife);
	o.display = 2
	o = instance_create_layer(x+1361, y+107, "Instances", oLife);
	o.display = 3
	o = instance_create_layer(x+1381, y+106, "Instances", oLife);
	o.display = 4
	o = instance_create_layer(x+1400, y+106, "Instances", oLife);
	o.display = 5
	o = instance_create_layer(x+1420, y+107, "Instances", oLife);
	o.display = 6
	o = instance_create_layer(x+1440, y+111, "Instances", oLife);
	o.display = 7
	o = instance_create_layer(x+1460, y+113, "Instances", oLife);
	o.display = 8
	o = instance_create_layer(x+1480, y+116, "Instances", oLife);
	o.display = 9
}

// Create Main Variables
// Global
global.playerCoins = 0;
global.playerWaves = 0;
global.playerLives = 10 * 10;

// Local
timer_var = 0;
clockSeconds = 0;
clockHandAngle = 0;
clockHandRevolutions = 0;
shopPage = 0;
shopName = 0;
shopDescription = 0;
weaponCost = 30;
objectSelected = 1;
weaponHUDLocation = 180;

mouseHover = 0;
hudWeaponSelection = 0;
hudWeaponName = "springboard";

// rotVar Testing
rotation_direction = 1; //1 clockwise  -1 counterclockwise
acceleration = 2;
r_speed = 2;
rotVarActive = 1;

// Sprite Font
global.fntSmall = font_add_sprite_ext(spr_spriteFontSmall, "0123456789abcdefghijklmnopqrstuvwxyz.:,*-!", true, 2);
global.fntBig = font_add_sprite_ext(spr_spriteFontBig, "abcdefghijklmnopqrstuvwxyz0123456789!:", true, 1);
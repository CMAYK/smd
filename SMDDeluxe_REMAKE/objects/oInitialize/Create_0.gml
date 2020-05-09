/// @desc oInitialize
// Set Screen
defaultW = 533
defaultH = 300
window_set_size(defaultW*2, defaultH*2);

// Import Scripts
sc_musicCreate()

// Create Important Objects
instance_create_layer(x, y, "Instances", oCamera);

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
mouseHover = 0;

// rotVar Testing
rotVar = 0;
rotVarActive = true;

// Sprite Font
global.fntSmall = font_add_sprite_ext(spr_spriteFontSmall, "0123456789abcdefghijklmnopqrstuvwxyz.:,*-!", true, 2);
global.fntBig = font_add_sprite_ext(spr_spriteFontBig, "abcdefghijklmnopqrstuvwxyz0123456789!:", true, 1);
/// @desc oInitialize
// Import Scripts
sc_musicCreate()

// Create Important Objects
instance_create_layer(x, y, "Instances", oCamera);

// Create Main Variables
// Global
global.timer_var = 0;
global.playerCoins = 0;
global.playerWaves = 0;
global.playerLives = 10;

// Local
shopPage = 0;
shopDescription = 0;

// Sprite Font
global.SMW = font_add_sprite_ext(spr_spriteFont, "0123456789abcdefghijklmnopqrstuvwxyz.:,*-!", true, 2);
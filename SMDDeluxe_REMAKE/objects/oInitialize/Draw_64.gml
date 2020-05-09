/// @desc oInitialize
// Draw Main HUD Interface
draw_sprite_ext(spr_hudMain, 0, x+265, y, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_hudMainSelect, mouseHover, x+200, y+48, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_hudMainSelect, mouseHover, x+490, y+48, -1, 1, 0, c_white, 1);
draw_sprite(spr_hudPause, 0, x+27, y+10);

// Draw Clock
draw_sprite_ext(spr_hudClock, mouseHover, x+74, y+49, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_hudClockHand, 0, x+74, y+49, 1, 1, clockHandAngle, c_white, 1);

// Draw Player Status
draw_set_font(global.fntSmall);
draw_sprite(spr_hudLives, 0, 123, 16);
draw_text(x+143, y+18, ":");
draw_text(x+150, y+18, string(global.playerLives));
draw_sprite(spr_hudWaves, 0, 123, 42);
draw_text(x+143, y+46, ":");
draw_text(x+150, y+46, string(global.playerWaves));
draw_sprite(spr_hudCoins, 0, 125, 68);
draw_text(x+143, y+72, ":");
draw_text(x+150, y+72, string(global.playerCoins));

// Draw Shop
draw_sprite(spr_hudShopDisplay, 0, x+260, y+48);
if (shopPage = 0) {
	draw_sprite_ext(spr_shopSpringboard, 0, x+260, y+48, 1, 1, rotVar, c_white, 1);
	shopDescription = 0;
}
if (shopName = 0) {
	draw_set_font(global.fntBig);
	draw_sprite(spr_hudCoins, 0, x+420, y+14);
	draw_text(x+308, y+15, "springboard");
	draw_text(x+434, y+15, ":");
	draw_text(x+440, y+15, string(weaponCost));
}
if (shopDescription = 0) {
	draw_set_font(global.fntSmall);
	draw_text(x+307, y+45, "bounces enemies");
	draw_text(x+303, y+54, "upwards, damaging");
	draw_text(x+312, y+63, "them when they");
	draw_text(x+311, y+73, "hit the ground.");
}

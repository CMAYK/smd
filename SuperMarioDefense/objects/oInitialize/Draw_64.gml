// Set Font
draw_set_font(global.SMW);

// Draw Main GUI
draw_sprite(spr_HUDmain, 0, 1, 1);
draw_sprite(spr_HUDselectLeft, 0, 195, 27);
draw_sprite(spr_HUDselectRight, 0, 440, 27);

// Draw Indicators
draw_sprite(spr_lives, 0, 110, 12);
draw_text(130, 16, ":");
draw_text(139, 16, string(global.livescounter));
draw_sprite(spr_level, 0, 110, 39);
draw_text(130, 43, ":");
draw_text(139, 43, string(waveCounter));
draw_sprite(spr_coins, 0, 111, 66);
draw_text(130, 70, ":");

// Draw Clock
draw_sprite(spr_clock, 0, 24, 12);
draw_sprite_ext(spr_clockHand, 0, 56, 50, 1, 1, clockHandAngle, c_white, 1);

// Draw Shop
draw_sprite(spr_HUDShopDisplayBG, 0, 225, 24);
if (shopPage = 0) {
	draw_sprite(spr_springBoardHUD, 0, 249, 48);
	shopDescription = 0;
}
if (shopDescription = 0) {
	draw_text(280, 25, "springboard\ncost:30\nbounces enemies\ndamaging them\nwhen they fall\nto the ground.")
}

// Debug Text
draw_text(32, 112, "fps - " + string(fps));
draw_text(300, 112, "shop - " + string(shopPage));
draw_text(300, 124, "timer - " + string(clockSeconds));
draw_text(300, 136, "wave - " + string(oEnemySpawner.wave));
if (instance_exists(oSpinnerBar)) { 
	draw_text(300, 148, "barmove - " + string(oSpinnerBar.spinnerMovement));
	draw_text(300, 160, "rotdirec - " + string(oSpinnerBar.rotationSpeed));
}
draw_text(300, 172, "speed - " + string(oEnemySpawner.spawnerSpeed));
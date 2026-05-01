/// @desc oInitialize
// Draw Main HUD Interface
draw_sprite_ext(spr_hudMain, 0, x+265, y, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_hudMainSelect, oHUDSelectL.mouseHover, x+200, y+48, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_hudMainSelect, oHUDSelectR.mouseHover, x+490, y+48, -1, 1, 0, c_white, 1);
draw_sprite(spr_hudPause, mouseHover, x+27, y+10);
// Draw Weapon UI
draw_sprite(spr_hudWeaponMain, hudWeaponSelection, weaponHUDLocation+437, y+165);
draw_sprite(spr_hudWeaponBMain, mouseHover, weaponHUDLocation+424, y+144);
draw_sprite(spr_hudWeaponBRange, mouseHover, weaponHUDLocation+446, y+144);
draw_sprite(spr_hudWeaponBDamage, mouseHover, weaponHUDLocation+468, y+144);
draw_sprite(spr_hudWeaponBSpeed, mouseHover, weaponHUDLocation+490, y+144);
draw_set_font(global.fntSmall);
draw_text(weaponHUDLocation+404, y+120, hudWeaponName);
draw_sprite(spr_shopSpringboard, 0, weaponHUDLocation+382, y+134);

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
sc_shopPages()
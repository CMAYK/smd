draw_sprite(spr_hudShopDisplay, 0, x+260, y+48);
if (shopPage = 0) {
	shopName = 0;
	shopDescription = 0;
	draw_sprite_ext(spr_shopSpringboard, 0, x+260, y+48, 2, 2, rotation_direction, c_white, 1);
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
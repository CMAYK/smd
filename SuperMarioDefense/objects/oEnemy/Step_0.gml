/// @description Insert description here
sc_determineCharacter();
sc_enemyWaves();
sc_debug();

vsp += grv;

// vertical collision
if (place_meeting(x,y+vsp,oWall))
{
	while (!place_meeting(x,y+sign(vsp),oWall))
	{
		y = y + sign(vsp);
	}
	vsp = 0;
}
y = y + vsp;

if (enemyHealth <= 0) {
	instance_destroy();
	instance_create_layer(x+5, y+8, "Instances", characterDefeated);
	audio_play_sound(snd_coin, 10, false);
	coinEffect = instance_create_layer(x, y, "Instances", oEffectCoin);
	coinEffect.dir = -30;
	coinEffect = instance_create_layer(x, y, "Instances", oEffectCoin);
	coinEffect.dir = 0;
	coinEffect = instance_create_layer(x, y, "Instances", oEffectCoin);
	coinEffect.dir = 180;
	coinEffect = instance_create_layer(x, y, "Instances", oEffectCoin);
	coinEffect.dir = 210;
}

move_contact_solid(90, stp);
move_contact_solid(0, spd);
move_contact_solid(270, stp);

// Springboard Damage
if (place_meeting(x,y+1,oWall)) && (willDamage) {
	enemyHealth -= willDamageId.springLevel;	
	willDamage = false;
	willDamageId = noone;
	stompEffect = instance_create_layer(x+1, y+10, "Instances", oEffectStomp);
	stompEffect.dir = 1;
	stompEffect = instance_create_layer(x+1, y+10, "Instances", oEffectStomp);
	stompEffect.dir = -1;
}

// Springboard SFX Fix
var curr_coll = place_meeting(x, y+1, oSpringplatform);
var prev_coll = place_meeting(xprevious, yprevious+1, oSpringplatform);

if ((curr_coll == 1) && (prev_coll == 0))
{
    audio_play_sound(snd_bounce, 10, false);
}
/// @desc Physics

sc_determineCharacter();
//sc_enemyWaves();

// Physics
vsp += grv;

// Vertical Collision
if (place_meeting(x,y+vsp,oWall))
{
	while (!place_meeting(x,y+sign(vsp),oWall))
	{
		y = y + sign(vsp);
	}
	vsp = 0;
}
y = y + vsp;


move_contact_solid(90, stp);
move_contact_solid(0, spd);
move_contact_solid(270, stp);

// Death
if (enemyHealth <= 0) {
	global.playerCoins += worth;
	instance_destroy();
	instance_create_layer(x, y-8, "Instances", characterDefeated);
	//audio_play_sound(snd_coin, 10, false);
}

// Springboard Damage
if (place_meeting(x,y+1,oWall)) && (willDamage) {
	enemyHealth -= willDamageId.springboardDamage;	
	willDamage = false;
	willDamageId = noone;
}

// Springboard SFX
var curr_coll = place_meeting(x, y+1, oSpringboard);
var prev_coll = place_meeting(xprevious, yprevious+1, oSpringboard);

if ((curr_coll == 1) && (prev_coll == 0))
{
    //audio_play_sound(snd_bounce, 10, false);
}

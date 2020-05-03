image_speed = -0.8;

vsp += grv;

// vertical collision
if (place_meeting(x,y+vsp,oWall))
{
	while (!place_meeting(x,y+sign(vsp),oWall))
	{
		y += sign(vsp);
	}
	vsp = 0;
}
y += vsp;

move_contact_solid(90, stp);
move_contact_solid(180, spd);
move_contact_solid(270, stp);

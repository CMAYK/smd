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

move_contact_solid(90, stp);
move_contact_solid(dir, spd);
move_contact_solid(270, stp);
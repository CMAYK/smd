vsp += grv;

// vertical collision
if (place_meeting(x,y+vsp,oWall))
{
	while (!place_meeting(x,y+sign(vsp),oWall))
	{
		y += sign(vsp);
	}
	instance_create_layer(x, y+15, "Weapons", oBomb);
	instance_destroy()
}
y += vsp;
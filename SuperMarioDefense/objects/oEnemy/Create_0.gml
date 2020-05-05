/// @desc Variables

depth = 1;

vsp = 0;
grv = 0.3;
stp = 20;
spd = 1;

level = oEnemySpawner.level;
enemyHealth = 1;

enemyHit = false;

willDamage = false;
willDamageId = noone;

type = 0; // small = 0, big = 1, fire = 2, cape = 3;
isHoldingBaby = 0; // if = 1 then isBoot + isRiding = 0;
isBoot = 0; // if = 1 then isRiding + isHoldingBaby = 0;
isRiding = 0; // if = 1 then isBoot + isHoldingBaby = 0;
character = irandom_range(0, 12); // Mario = 0 - 5, Luigi = 6 - 9, Toad = 10 - 12;
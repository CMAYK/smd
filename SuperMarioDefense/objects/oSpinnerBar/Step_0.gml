spinnerMovement = clamp(spinnerMovement- rotationSpeed, -90, 90);

if (spinnerMovement == -90) or (spinnerMovement == 90) {
	rotationSpeed *= -1;
}


image_angle = spinnerMovement;
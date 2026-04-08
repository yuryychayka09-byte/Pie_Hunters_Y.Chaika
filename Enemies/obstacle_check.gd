extends RayCast2D


if $ObstacleCheck.is_colliding() and is_on_floor():
	velocity.y = -300
	anim.play("Jump")

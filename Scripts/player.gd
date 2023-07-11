extends CharacterBody2D


@export var speed : float = 10000

var move_Direction = Vector2.ZERO


func _physics_process(delta):
	move_Direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_Direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")


	if(move_Direction.x != 0):
		move_Direction.y = 0

	velocity = move_Direction.normalized() * speed * delta
	move_and_slide()


# OLD CODE DOWN HERE.
# commented because of i don't want player to sliding like a fucking ball.
# but in new code (up here) a problem with diagonal movement. i'll try to fix it now.

#const MAX_SPEED = 110
#const ACCELERATION = 450
#const FRICTION = 1000
#
#@onready var axis = Vector2.ZERO
#
#
#func _physics_process(delta):
#	move(delta)
#
#
#func get_input_axis():
#	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
#	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
#
#	return axis.normalized()
#
#
#func move(delta):
#	axis = get_input_axis()
#
#	if axis == Vector2.ZERO:
#		apply_friction(FRICTION * delta)
#	else:
#		apply_movement(axis * ACCELERATION * delta)
#
#	move_and_slide()
#
#
#func apply_friction(amount):
#	if velocity.length() > amount:
#		velocity -= velocity.normalized() * amount
#	else:
#		velocity = Vector2.ZERO
#
#
#func apply_movement(accel):
#	velocity += accel
#	velocity = velocity.limit_length(MAX_SPEED)

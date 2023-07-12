extends CharacterBody2D


@export var speed : float = 10000

var moveDirection = Vector2.ZERO


func _physics_process(delta):
	moveDirection.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveDirection.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	velocity = moveDirection.normalized() * speed * delta
	move_and_slide()

func _on_leave_level_trigger_body_entered(body):
	var currentSceneNum = int(get_parent().name.right(1))
	if currentSceneNum == 5:
		print("end")
		return
	get_tree().change_scene_to_file("res://Scenes/Levels/level{levelNum}.tscn".format({"levelNum": currentSceneNum + 1}))
	
	
# OLD CODE DOWN HERE.
# commented because of i don't want player to sliding like a fucking ball.
# but in new code (up here) a problem with diagonal movement. i'll try to fix it now.
# UPD: fixed.
# code down below for history, but i don't think we'll use it.

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

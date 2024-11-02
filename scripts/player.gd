extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity += get_gravity() * delta

	# Handle vertical.
	if Input.is_action_just_pressed("ui_up"):# and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("ui_down"):# and is_on_floor():
		velocity.y = -JUMP_VELOCITY
	if Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_down"):
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()




func _on_wall_body_entered(body:Node2D):
	position = Vector2(0, 0)
	pass # Replace with function body.

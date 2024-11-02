extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@export var friction = 0.18
@onready var ai_controller: Node2D = $AIController2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# # Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# # Get the input direction and handle the movement/deceleration.
	# # As good practice, you should replace UI actions with custom gameplay actions.
	# var direction = Input.get_axis("ui_left", "ui_right")
	# if direction:
	# 	velocity.x = direction * SPEED
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)

	#velocity.x = move_toward(ai_controller.move.x, 0, SPEED)
	#velocity.y = ai_controller.move.y

	var direction = ai_controller.move
	if direction.length() > 1.0:
		direction = direction.normalized()
	# Using the follow steering behavior.
	var target_velocity = direction * SPEED
	velocity.x += (target_velocity.x - velocity.x) * friction
	move_and_slide()


func _on_wall_body_entered(body:Node2D):
	position = Vector2(0, 0)
	ai_controller.reward -= 1.0
	ai_controller.reset()
	pass # Replace with function body.


func _on_target_body_entered(body:Node2D):
	position = Vector2(0, 0)
	ai_controller.reward += 1.0
	pass # Replace with function body.

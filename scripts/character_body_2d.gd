extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var seen_player = false
var follow_position
var direction
var search_quad

@export var friction = 0.18
@onready var ai_controller: Node2D = $AIController2D
@onready var LOS: Area2D = $LOS
@onready var quad_timer: Timer = $ChangeQuad
@onready var player: CharacterBody2D = $"../Player"

func _ready():
	_on_change_quad_timeout()
	quad_timer.start()

func _physics_process(delta):
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity += get_gravity() * delta

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
	if seen_player:
		direction = position - player.position
		#print("Going in dir: ", direction)
	else:
		direction = ai_controller.move
		#print("Rotating: ", ai_controller.turn_degree)
		LOS.rotation = ai_controller.turn_degree * 360.0
	if direction.length() > 1.0:
		direction = direction.normalized()
	# Using the follow steering behavior.
	var target_velocity = direction * SPEED
	velocity += (target_velocity - velocity) * friction
	move_and_slide()



func _on_wall_body_entered(body:Node2D):
	position = Vector2(0, 0)
	ai_controller.reward -= 1.0
	ai_controller.reset()
	pass # Replace with function body.


func _on_target_body_entered(body:Node2D):
	print("Reward")
	position = Vector2(0, 0)
	ai_controller.reward += 1.0
	pass # Replace with function body.


func _on_los_body_entered(body:Node2D):
	if body.name == "Player":
		print("Detected player")
		ai_controller.reward += 1.0
		seen_player = true

func _on_los_body_exited(body:Node2D):
	if body.name == "Player":
		print("Lost player")
		ai_controller.reward -= 1.0
		seen_player = false

func _on_change_quad_timeout():
	search_quad = ai_controller.quadrant
	var name = "Quad" + str(ai_controller.quadrant)
	#print("Parent: ", get_parent())
	var tgt_quad = get_parent().get_node(name)
	print("I chose to look in quad: ", tgt_quad)
	position = tgt_quad.position
	quad_timer.start()
	pass # Replace with function body.

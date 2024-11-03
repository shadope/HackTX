extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var seen_player = false
var follow_position
var direction
var search_quad
var moving_to_quad = false
var tgt_quad_name = ""
var tgt_quad

@export var friction = 0.18
@onready var ai_controller: Node2D = $AIController2D
@onready var LOS: Area2D = $LOS
@onready var quad_timer: Timer = $ChangeQuad
@onready var player: CharacterBody2D = $"../Player"

func _ready():
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
		direction = player.position - position
		print("Rotating: ", LOS.rotation)
		#print("Going in dir: ", direction)
	elif moving_to_quad:
		LOS.look_at(tgt_quad.position) #acos((player.position.dot(position))/(player.position.length() * position.length()))
		direction = tgt_quad.position - position
		if direction.length() < 1.0:
			moving_to_quad = false
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
	if body.name == "Agent":
		print("Reward")
		position = Vector2(0, 0)
		ai_controller.reward += 1.0
	pass # Replace with function body.
	
	
func _on_los_body_entered(body:Node2D):
	if body.name == "Player":
		print("Detected player")
		#LOS.look_at(player.position) #acos((player.position.dot(position))/(player.position.length() * position.length()))
		ai_controller.reward += 1.0
		seen_player = true
		
func _on_los_body_exited(body:Node2D):
	if body.name == "Player":
		#print("Lost player")
		ai_controller.reward -= 1.0
		seen_player = false
		
func _on_change_quad_timeout():
	search_quad = ai_controller.quadrant
	tgt_quad_name = "Quad" + str(ai_controller.quadrant)
	#print("Parent: ", get_parent())
	tgt_quad = get_parent().get_node(tgt_quad_name)
	#print("I chose to look in quad: ", tgt_quad)
	direction = tgt_quad.position - position
	LOS.rotation = acos((tgt_quad.position.dot(position))/(tgt_quad.position.length() * position.length()))
	moving_to_quad = true
	print("Tgt name: ", tgt_quad_name)
	quad_timer.start()
	pass # Replace with function body.
	
func _on_area_2d_area_entered(area):
	#print("Entering area")
	#print("My groups: ", area.get_parent().get_groups())
	if "Quad" in area.get_parent().get_groups():
		#print("Entering a quad")
		#print("my parent's name is: ", area.get_parent().name)
		if tgt_quad and tgt_quad.name == area.get_parent().name:
			#print("Entering tgt area")
			moving_to_quad = false
	pass # Replace with function body.
	
func _on_area_2d_area_exited(area):
	if "Quad" in area.get_parent().get_groups():
		#print("Entering a quad")
		if tgt_quad and tgt_quad.name == area.get_parent().name:
			moving_to_quad = true
	pass # Replace with function body.
	

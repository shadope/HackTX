extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@export var friction = 0.18
@export var training = false
@onready var ai_controller: Node2D = $AIController2D

#signals
signal player_hide(val)
signal player_reset()
signal get_reward()

func _ready():
	player_hide.connect(_on_hidden)
	player_reset.connect(_on_reset)
	get_reward.connect(_on_reward)

func _physics_process(delta):
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity += get_gravity() * delta

	if training:
		var direction = ai_controller.move
		if direction.length() > 1.0:
			direction = direction.normalized()
		# Using the follow steering behavior.
		var target_velocity = direction * SPEED
		velocity += (target_velocity - velocity) * friction

	else:
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

func _on_target_body_entered(body:Node2D):
	if body.name == "Agent" and self.visible:
		#print("Ran into enemy")
		ai_controller.reward -= 1.0
		#ai_controller.reset()
	pass # Replace with function body.


func _on_detection_rad_body_entered(body:Node2D):
	if body.name == "Agent" and self.visible:
		print("Detect enemy")
		ai_controller.reward -= 1.0
	pass # Replace with function body.



func _on_hidden(val : bool):
	if val:
		self.visible = false
	else:
		self.visible = true
		
func _on_reset() -> void:
	self.visible = true
	
func _on_reward():
	print("Got a reward!")
	ai_controller.reward += 1.0

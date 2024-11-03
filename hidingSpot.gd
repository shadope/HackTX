extends Node2D

var playerInside = false

@onready var detectArea = $Area2D
@onready var hideLabel = $hideLabel
@onready var timer = $Timer
@onready var bar = $timeBar
@onready var area = $Area2D

#local vars
var hideLabels = ["Press 'E' to Hide!", "Press 'E' to Exit"]
var quad
#signals
signal hiding_reset()

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect the area2d signals
	hiding_reset.connect(_on_reset)
	bar.value = 0.0
	bar.max_value = timer.wait_time
	self.add_to_group("hiding_spots")
	

	#detectArea.connect("body_entered", _on_area_2d_body_entered)
	#detectArea.connect("body_exited", _on_area_2d_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !self.quad:
		for quad in get_tree().get_nodes_in_group("Quad"):
			print("cur quad: ", quad.name, " ", self.get_node("Area2D").get_overlapping_areas())
			if quad.get_node("Area2D").overlaps_area(area):
				print("made it here haha, ",quad.name)
				self.quad = quad
	if Input.is_action_just_pressed("hide") and hideLabel.visible:
		hide_action()
	if !timer.is_stopped():
		#update progress bar
		bar.value = timer.wait_time - timer.time_left
		
		
#make it so that when player presses e over a hinding spot it goes into it
func _on_area_2d_body_entered(body:Node2D):
	print("body names: ", body.name)
	if body.name == "Player":
		#we want to display the E press so the user can know that they can enter
		hideLabel.visible = true
	elif body.name == "Agent":
		#agent has entered our zone
		print("agent going into spot")
		self.get_parent().get_node("Agent").emit_signal("spot_near", self)
	elif body.is_in_group("Quad"):
		self.quad = body

func _on_area_2d_body_exited(body:Node2D):
	if body.name == "Player":
		#we want to display the E press so the user can know that they can enter
		hideLabel.visible = false
		bar.visible = false
	elif body.name == "Agent":
		#agent has exited our zone
		self.get_parent().get_node("Agent").emit_signal("spot_left", self)
		
		
		
func hide_action() -> void:
	if hideLabel.text == hideLabels[0]:
		#they have entered and are now hiding
		hideLabel.text = hideLabels[1]
		self.get_parent().get_node("Player").emit_signal("player_hide", true)
		timer.start()
		bar.visible = true
	else:
		self.get_parent().get_node("Player").emit_signal("player_hide", false)
		hideLabel.text = hideLabels[0]
		bar.visible = false
		
		
func _on_reset():
	self.hideLabel.text = hideLabels[0]
	self.hideLabel.visible = false


func _on_timer_timeout() -> void:
	#player has been in hidng too long, kick them out!
	hide_action()
	timer.stop()
	bar.value = 0.0
	
func search() -> void:
	print("inside spot code seraching")
	if hideLabel.text == hideLabels[1]:
		#TODO make this work for arrays
		print("player was inside")
		self.get_parent().get_node("Agent").emit_signal("spot_searched", true)
		#kick the player out
		hide_action()
	else:
		print("player was not inside")
		self.get_parent().get_node("Agent").emit_signal("spot_searched", false)

	

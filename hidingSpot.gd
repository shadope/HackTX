extends Node2D

var playerInside = false
@onready var detectArea = $Area2D
@onready var hideLabel = $hideLabel

var hideLabels = ["Press 'E' to Hide!", "Press 'E' to Exit"]

#signals
signal hiding_reset()

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect the area2d signals
	hiding_reset.connect(_on_reset)
	#detectArea.connect("body_entered", _on_area_2d_body_entered)
	#detectArea.connect("body_exited", _on_area_2d_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("hide") and hideLabel.visible:
		hide_action()
		
#make it so that when player presses e over a hinding spot it goes into it
func _on_area_2d_body_entered(body:Node2D):
	if body.name == "Player":
		#we want to display the E press so the user can know that they can enter
		hideLabel.visible = true

func _on_area_2d_body_exited(body:Node2D):
	if body.name == "Player":
		#we want to display the E press so the user can know that they can enter
		hideLabel.visible = false
		
func hide_action() -> void:
	if hideLabel.text == hideLabels[0]:
		#they have entered
		hideLabel.text = hideLabels[1]
		self.get_parent().get_node("Player").emit_signal("player_hide", true)
	else:
		self.get_parent().get_node("Player").emit_signal("player_hide", false)
		hideLabel.text = hideLabels[0]
		
		
func _on_reset():
	self.hideLabel.text = hideLabels[0]
	self.hideLabel.visible = false

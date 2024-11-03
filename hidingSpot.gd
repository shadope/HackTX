extends Node2D

var playerInside = false
@onready var detectArea = $Area2D
@onready var hideLabel = $hideLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect the area2d signals
	pass
	#detectArea.connect("body_entered", _on_area_2d_body_entered)
	#detectArea.connect("body_exited", _on_area_2d_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("hide") and hideLabel.visible:
		print("pressing E")
		self.get_parent().get_node("Player").emit_signal("player_hide", true)
		

#make it so that when player presses e over a hinding spot it goes into it
func _on_area_2d_body_entered(body:Node2D):
	if body.name == "Player":
		#we want to display the E press so the user can know that they can enter
		hideLabel.visible = true


func _on_area_2d_body_exited(body:Node2D):
	if body.name == "Player":
		#we want to display the E press so the user can know that they can enter
		hideLabel.visible = false

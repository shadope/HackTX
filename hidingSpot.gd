extends Node2D

var playerInside = false

@onready var detectArea = $Area2D
@onready var hideLabel = $hideLabel
@onready var timer = $Timer
@onready var bar = $timeBar

var hideLabels = ["Press 'E' to Hide!", "Press 'E' to Exit"]

#signals
signal hiding_reset()

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect the area2d signals
	hiding_reset.connect(_on_reset)
	bar.value = 0.0
	bar.max_value = timer.wait_time
	#detectArea.connect("body_entered", _on_area_2d_body_entered)
	#detectArea.connect("body_exited", _on_area_2d_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("hide") and hideLabel.visible:
		hide_action()
	if !timer.is_stopped():
		#update progress bar
		bar.value = timer.wait_time - timer.time_left
		
		
#make it so that when player presses e over a hinding spot it goes into it
func _on_area_2d_body_entered(body:Node2D):
	if body.name == "Player":
		#we want to display the E press so the user can know that they can enter
		hideLabel.visible = true

func _on_area_2d_body_exited(body:Node2D):
	if body.name == "Player":
		#we want to display the E press so the user can know that they can enter
		hideLabel.visible = false
		bar.visible = false
		
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

	

extends Node2D

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		random.randomize()
		body.emit_signal("get_reward")
		position = Vector2(randi_range(-300, 300), randi_range(-100, 100))
	pass # Replace with function body.

extends AIController2D

var move = Vector2.ZERO
var turn_degree = 0.0
var quadrant = 0

@onready var player: CharacterBody2D = $".."
@onready var target: Area2D = $"../../Player/Target"

#-- Methods that need implementing using the "extend script" option in Godot --#
func get_obs() -> Dictionary:

	var obs := [
		player.position.x,
		player.position.y,
		target.position.x,
		target.position.y,
		0
	]
	
	#obs.append_array(raycast_obs)
	#assert(false, "the get_obs method is not implemented when extending from ai_controller")
	return {"obs": obs}


func get_reward() -> float:
	return reward;
	# assert(false, "the get_reward method is not implemented when extending from ai_controller")
	# return 0.0


func get_action_space() -> Dictionary:
	# assert(
	# 	false,
	# 	"the get get_action_space method is not implemented when extending from ai_controller"
	# )
	return {
		"move": {"size": 2, "action_type": "continuous"},
		"turn": {"size": 1, "action_type": "continuous"},
		"quad": {"size": 1, "action_type": "continuous"}
		#"example_actions_discrete": {"size": 2, "action_type": "discrete"},
	}


func set_action(action) -> void:
	move.x = action["move"][0]
	move.y = action["move"][1]
	turn_degree = action["turn"][0]
	quadrant = clamp(action["quad"][0],-1.0,1.0)
	if quadrant > -1 and quadrant <= -0.5:
		quadrant = 0
	elif quadrant > -0.5 and quadrant <= 0:
		quadrant = 1
	elif quadrant > 0 and quadrant <= 0.5:
		quadrant = 2
	else:
		quadrant = 3

	#assert(false, "the set_action method is not implemented when extending from ai_controller")

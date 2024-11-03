extends AIController2D


@onready var player: CharacterBody2D = $".."
@onready var target: Node2D = $"../../Reward"

var move: Vector2 = Vector2.ZERO

#-- Methods that need implementing using the "extend script" option in Godot --#
func get_obs() -> Dictionary:
	# Code from ball chase example by edbeeching
	var relative = to_local(target.global_position)
	var distance = relative.length() / 1500.0
	relative = relative.normalized()
	var result := []
	result.append(((position.x / 50) - 0.5) * 2)
	result.append(((position.y / 50) - 0.5) * 2)
	result.append(relative.x)
	result.append(relative.y)
	result.append(distance)
	#var raycast_obs = player.raycast_sensor.get_observation()
	#result.append_array(raycast_obs)
	
	var obs := [
		player.position.x,
		player.position.y,
		target.position.x,
		target.position.y,
	]
	
	return {
		"obs": result,
	}
	
	
#
	##assert(false, "the get_obs method is not implemented when extending from ai_controller")
	#return {"obs": obs}


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
		#"example_actions_discrete": {"size": 2, "action_type": "discrete"},
	}

func set_action(action) -> void:
	move.x = action["move"][0]
	move.y = action["move"][1]

	#assert(false, "the set_action method is not implemented when extending from ai_controller")

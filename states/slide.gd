extends PlayerState

var slide_timer = 0.5  # Adjust for slide duration

func enter(previous_state_path: String, data := {}) -> void:
	print("is sliding")
	CharacterPlayer.is_sliding = true

	# Store direction at start of slide
	CharacterPlayer.slide_direction = CharacterPlayer.velocity.normalized()

	# Increase speed
	CharacterPlayer.velocity += CharacterPlayer.slide_direction * CharacterPlayer.sliding_boost

	# Reduce collider height for sliding effect
	CharacterPlayer.collision_shape.shape.height *= 0.5  

	# Release crouch input
	Input.action_release("crouch_or_uncrouch")

func physics_update(delta: float) -> void:
	slide_timer -= delta
	if slide_timer <= 0 or !CharacterPlayer.is_moving(): 
		finished.emit(Standing)  # Exit slide if time is up or player stops

func exit() -> void:
	# Restore player height when exiting slide
	CharacterPlayer.collision_shape.shape.height *= 2  
	CharacterPlayer.is_sliding = false

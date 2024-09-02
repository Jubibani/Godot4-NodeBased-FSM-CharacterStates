extends PlayerState

func enter(previous_state_path: String, data = {}) -> void:

	
	print("Crouch State: ", "crouching: %s, proning: %s" % [str(crouchingFromStand), str(proning)]) 
	
	if crouchingFromStand:
		CharacterPlayer.animation_player.play("StandCrouching", -1, CharacterPlayer.animation_speed)
		print("Entering Crouching State - ",  "crouching: %s, proning: %s" % [str(crouchingFromStand), str(proning)])
		
	elif crouchingFromProne and not proning:
		CharacterPlayer.animation_player.play("ProneCrouching", -1, -CharacterPlayer.animation_speed, true)
		print("Transitioning from Prone to Crouch - ",  "crouching: %s, proning: %s" % [str(crouchingFromProne), str(proning)])
		
	crouchingFromProne = true
	crouchingFromStand = true
	proning = false

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("crouch_or_uncrouch"):
		crouchingFromStand = true
		finished.emit(Standing)  # Transition back to standing
	elif Input.is_action_just_pressed("prone_or_unprone"):
		crouchingFromStand = false
		proning = true
		finished.emit(Proning)  # Transition to proning

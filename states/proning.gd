extends PlayerState

func enter(previous_state_path: String, data = {}) -> void:	
	
	if not crouchingFromProne and proning:
		CharacterPlayer.animation_player.play("ProneCrouching", -1, CharacterPlayer.animation_speed)
		print("Transitioning from Crouch to Prone - ",  "crouching: %s, proning: %s" % [str(crouchingFromProne), str(proning)])
	else:
		CharacterPlayer.animation_player.play("StandProne", -1, CharacterPlayer.animation_speed)
		print("Entering Proning State - ",  "crouching: %s, proning: %s" % [str(crouchingFromProne), str(proning)])
		
	crouchingFromProne = false
	proning = true


func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("prone_or_unprone"):
		proning = true
		print("Physics_update - ",  "crouching: %s, proning: %s" % [str(crouchingFromProne), str(proning)])
		finished.emit(Standing)  # Transition back to standing

	elif Input.is_action_just_pressed("crouch_or_uncrouch") and not crouchingFromProne and proning:
		crouchingFromProne = true
		proning = false
		print("Physics_update - ",  "crouching: %s, proning: %s" % [str(crouchingFromProne), str(proning)])
		finished.emit(ProneCrouching)

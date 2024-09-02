extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if crouchingFromStand:
		CharacterPlayer.animation_player.play("StandCrouching", -1, -CharacterPlayer.animation_speed, true)
		print("Standing from crouch - ",  "crouching: %-8s proning: %s" % [str(crouchingFromStand), str(proning)])
	
	elif crouchingFromProne and not proning:
		CharacterPlayer.animation_player.play("StandCrouching", -1, -CharacterPlayer.animation_speed, true)
		print("crouchingFromProne - ",  "crouching: %-8s proning: %s" % [str(crouchingFromStand), str(proning)])	
	elif proning:
		CharacterPlayer.animation_player.play("StandProne", -1, -CharacterPlayer.animation_speed, true)
		print("Standing from prone - ",  "crouching: %-8s proning: %s" % [str(crouchingFromStand), str(proning)])
	
	else:
		print("Already standing - ",  "crouching: %-8s proning: %s" % [str(crouchingFromStand), str(proning)])

	# Reset state flags
	crouchingFromStand = false
	crouchingFromProne = false
	proning = false

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("crouch_or_uncrouch"):
		crouchingFromStand = true
		finished.emit(StandCrouching)
	
	if Input.is_action_just_pressed("prone_or_unprone"):
		proning = true
		finished.emit(Proning)

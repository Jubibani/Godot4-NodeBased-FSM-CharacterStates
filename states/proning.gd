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
	
	#mute footstep
	CharacterPlayer.footstep_sound.volume_db = -100
	
	#add sound
	CharacterPlayer.proning_sound.play()
	CharacterPlayer.proning_sound.volume_db = -50
	
	CharacterPlayer.SPEED = CharacterPlayer.proning_speed
	print("proning speed at: ", CharacterPlayer.SPEED)
	
	
	#!release the buttons pressed
	Input.action_release("crouch_or_uncrouch")
	Input.action_release("prone_or_unprone")
	Input.action_release("run")
	Input.action_release("Jump")
	
func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("prone_or_unprone") or Input.is_action_just_pressed("Jump"):
		proning = true
		print("Physics_update - ",  "crouching: %s, proning: %s" % [str(crouchingFromProne), str(proning)])
		finished.emit(Standing)  # Transition back to standing
		Input.action_release("prone_or_unprone")
		Input.action_release("Jump")


	elif Input.is_action_just_pressed("crouch_or_uncrouch") and not crouchingFromProne and proning:
		crouchingFromProne = true
		proning = false
		print("Physics_update - ",  "crouching: %s, proning: %s" % [str(crouchingFromProne), str(proning)])
		finished.emit(ProneCrouching) 
		Input.action_release("crouch_or_uncrouch")



func _on_crouch_pressed() -> void:
	Input.action_press("crouch_or_uncrouch")


func _on_prone_pressed() -> void:
	Input.action_press("prone_or_unprone")

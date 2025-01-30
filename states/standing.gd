extends PlayerState
func enter(previous_state_path: String, data := {}) -> void:
	#by default, speed is walking speed
	CharacterPlayer.SPEED = CharacterPlayer.walking_speed
	print("walking speed at: ", CharacterPlayer.SPEED)
	
	if crouchingFromStand:
		CharacterPlayer.animation_player.play("StandCrouching", -1, -CharacterPlayer.animation_speed, true)
		#add sound
		CharacterPlayer.standing_sound.play()
		CharacterPlayer.standing_sound.volume_db = -35
		
		print("Standing from crouch - ",  "crouching: %-8s proning: %s" % [str(crouchingFromStand), str(proning)])
	
	elif crouchingFromProne and not proning:
		CharacterPlayer.animation_player.play("StandCrouching", -1, -CharacterPlayer.animation_speed, true)
		print("crouchingFromProne - ",  "crouching: %-8s proning: %s" % [str(crouchingFromStand), str(proning)])	
	elif proning:
		CharacterPlayer.animation_player.play("StandProne", -1, -CharacterPlayer.animation_speed, true)
		#add sound
		CharacterPlayer.standing_sound.play()
		CharacterPlayer.standing_sound.volume_db = -35
		
		print("Standing from prone - ",  "crouching: %-8s proning: %s" % [str(crouchingFromStand), str(proning)])
	
	else:
		print("Already standing - ",  "crouching: %-8s proning: %s" % [str(crouchingFromStand), str(proning)])
	
	#add footstep
	CharacterPlayer.step_interval = 0.6
	CharacterPlayer.footstep_sound.volume_db = -35
	

	
	

	
	# Reset state flags
	crouchingFromStand = false
	crouchingFromProne = false
	proning = false
	
	#!release the buttons pressed
	Input.action_release("crouch_or_uncrouch")
	Input.action_release("prone_or_unprone")
	Input.action_release("run")
	Input.action_release("Jump")


func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("crouch_or_uncrouch"):

		
		crouchingFromStand = true
		finished.emit(StandCrouching)
		Input.action_release("crouch_or_uncrouch")
		
	
	if Input.is_action_just_pressed("prone_or_unprone"):

		
		proning = true
		finished.emit(Proning) 
		Input.action_release("prone_or_unprone")
		
		
	if Input.is_action_just_pressed("run"):
		finished.emit(Running)
		Input.action_release("run")
		
		
	if Input.is_action_just_pressed("Jump") and CharacterPlayer.is_on_floor():
		finished.emit(Jumping)
		Input.action_release("Jump")
		


func _on_run_pressed() -> void:
	Input.action_press("run")


func _on_jump_pressed() -> void:
	Input.action_press("Jump")


func _on_crouch_pressed() -> void:
	Input.action_press("crouch_or_uncrouch")


func _on_prone_pressed() -> void:
	Input.action_press("prone_or_unprone")

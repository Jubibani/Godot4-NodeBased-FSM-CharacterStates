extends PlayerState

func enter(previous_state_path: String, data = {}) -> void:
	
	CharacterPlayer.animation_player.play("ProneCrouching", -1, -CharacterPlayer.animation_speed, true)
	print("Transitioning from Prone to Crouch - ",  "crouching: %s, proning: %s" % [str(crouchingFromProne), str(proning)])
	
	crouchingFromProne = true
	proning = false
		
	#mute footstep
	CharacterPlayer.footstep_sound.volume_db = -100
	
	#add sound
	CharacterPlayer.crouching_sound.play()
	CharacterPlayer.crouching_sound.volume_db = -35
		
	CharacterPlayer.SPEED = CharacterPlayer.crouching_speed
	print("crouching speed at: ", CharacterPlayer.SPEED)
	
	#!release the buttons pressed
	Input.action_release("crouch_or_uncrouch")
	Input.action_release("prone_or_unprone")
	Input.action_release("run")
	Input.action_release("Jump")
	
func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("crouch_or_uncrouch") or Input.is_action_just_pressed("Jump") and crouchingFromProne and not proning:
		finished.emit(Standing)  # Transition back to standing
		Input.action_release("crouch_or_uncrouch")
		Input.action_release("Jump")
		
		
	if Input.is_action_just_pressed("prone_or_unprone") and crouchingFromProne and not proning:
		finished.emit(Proning) 
		Input.action_release("prone_or_unprone")
		
	



func _on_crouch_pressed() -> void:
	Input.action_press("crouch_or_uncrouch")


func _on_prone_pressed() -> void:
	Input.action_press("prone_or_unprone")

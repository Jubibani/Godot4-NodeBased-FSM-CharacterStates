extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	# Handle jump.
	CharacterPlayer.velocity.y = CharacterPlayer.JUMP_VELOCITY
	CharacterPlayer.player_jumped = true
		
		
	#!release the buttons pressed
	Input.action_release("crouch_or_uncrouch")
	Input.action_release("prone_or_unprone")
	Input.action_release("run")
	Input.action_release("Jump")
	

func physics_update(_delta: float) -> void:
	if CharacterPlayer.is_on_floor():
		
		if CharacterPlayer.player_jumped:
			CharacterPlayer.jumplanding_sound.play()
			CharacterPlayer.jumplanding_sound.volume_db = -30
			
			#reset
			CharacterPlayer.player_jumped = false
		
		if Input.is_action_just_pressed("crouch_or_uncrouch"):
			crouchingFromStand = true
			finished.emit(StandCrouching)
			Input.action_release("crouch_or_uncrouch")
	
		
		if Input.is_action_just_pressed("prone_or_unprone"):
			proning = true
			finished.emit(Proning) 
			Input.action_release("prone_or_unprone")

		
			
		if Input.is_action_just_pressed("run"):
			finished.emit(Standing)
			Input.action_release("run")

			
		if Input.is_action_just_pressed("Jump") and CharacterPlayer.is_on_floor():
			finished.emit(Jumping)
			Input.action_release("Jump")
			
	#! this is to release these pressed buttons when pressed midair
	Input.action_release("run")	
	Input.action_release("Jump")
			





func _on_run_pressed() -> void:
	Input.action_press("run")


func _on_jump_pressed() -> void:
	Input.action_press("Jump")


func _on_crouch_pressed() -> void:
	Input.action_press("crouch_or_uncrouch")


func _on_prone_pressed() -> void:
	Input.action_release("prone_or_unprone")

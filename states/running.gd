extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	CharacterPlayer.SPEED = CharacterPlayer.running_speed
	print("running speed at: ", CharacterPlayer.SPEED)
	
	#!release the buttons pressed
	Input.action_release("prone_or_unprone")
	Input.action_release("run")
	Input.action_release("Jump")
	
	#add footstep
	CharacterPlayer.step_interval = 0.3 # Increased to simulate runnning
	CharacterPlayer.footstep_sound.volume_db = -35


func physics_update(_delta: float) -> void:
	
	if Input.is_action_just_pressed("crouch_or_uncrouch"):
		finished.emit(Sliding)
		Input.action_release("crouch_or_uncrouch")

	
	if Input.is_action_just_pressed("prone_or_unprone"):
		proning = true
		finished.emit(Proning) 
		Input.action_release("prone_or_unprone")

		
	if Input.is_action_just_pressed("run"):
		
		finished.emit(Standing)
	
		
	
	if Input.is_action_just_pressed("Jump"):
		finished.emit(Jumping)



func _on_run_pressed() -> void:
	Input.action_press("run")


func _on_jump_pressed() -> void:
	Input.action_press("Jump")


func _on_crouch_pressed() -> void:
	Input.action_press("crouch_or_uncrouch")


func _on_prone_pressed() -> void:
	Input.action_press("prone_or_unprone")

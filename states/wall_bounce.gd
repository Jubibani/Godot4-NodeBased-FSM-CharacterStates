extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	print("wallbounce")
	CharacterPlayer.is_wall_bouncing = true
	
	wall_bounce()
		
	#!release the buttons pressed
	Input.action_release("crouch_or_uncrouch")
	Input.action_release("prone_or_unprone")
	Input.action_release("run")
	Input.action_release("Jump")


func physics_update(_delta: float) -> void:
	CharacterPlayer.is_wall_bouncing = false
	finished.emit(Jumping)
	
			
	#! this is to release these pressed buttons when pressed midair
	Input.action_release("run")	
	Input.action_release("Jump")
			


#feature movement
func wall_bounce():
	if CharacterPlayer.is_on_wall() and CharacterPlayer.wall_bounce_availability > 0:
		CharacterPlayer.last_wall_normal = CharacterPlayer.get_wall_normal()  # Get direction of the wall
		print("Wall Bounce Normal: ", CharacterPlayer.last_wall_normal)  # Debugging

		# Remove vertical component of the normal (prevents bouncing upwards)
		CharacterPlayer.last_wall_normal.y = 0
		CharacterPlayer.last_wall_normal = CharacterPlayer.last_wall_normal.normalized()

		# Apply bounce force in the wall's normal direction + some forward movement
		CharacterPlayer.velocity = (CharacterPlayer.last_wall_normal * CharacterPlayer.wall_bounce_multiplier * CharacterPlayer.SPEED) + Vector3(0, CharacterPlayer.wall_boost, 0)
		CharacterPlayer.is_wall_bouncing = true
		
		#limit wall bounce usage to 3 and decrement until 0
		CharacterPlayer.wall_bounce_availability -=1
		print("Available wall bounce left: ", CharacterPlayer.wall_bounce_availability)
		
		
		Input.action_release("Jump")

		#add wall bounce sound
		CharacterPlayer.wallbounce_sound.play()
		CharacterPlayer.wallbounce_sound.volume_db = -30
	#to prevent unlimited wall bounce
	elif CharacterPlayer.wall_bounce_availability <= 0:
		print("No more wall bounce left!")
		#the wall bounce resets in player script
		

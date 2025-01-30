class_name CharacterPlayer extends CharacterBody3D

@export var animation_player : AnimationPlayer
@export_range(5.0, 5.0, 10.0)var animation_speed = 3.5
var SPEED = walking_speed

var is_running : bool = false
var is_crouching : bool = false
var is_on_air : bool = false
var player_jumped: bool = false

const running_speed = 10.0
const walking_speed = 5.5
const crouching_speed = 2.5
const proning_speed = 2.0
const JUMP_VELOCITY = 4.5

#head bobbing
const bob_frequency = 2.0
const bob_amplitude = 0.08
var t_bob = 0.0

#FOV
const base_fov = 75.0
const fov_change = 1.5


@onready var camera = $head/Camera3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#sounds
@onready var footstep_sound = $FootStepSound
@onready var jumplanding_sound = $JumpLandSound
@onready var crouching_sound = $CrouchSound
@onready var proning_sound = $ProneSound
@onready var standing_sound = $StandSound



# Walking sound timer
var time_since_step = 0.0
var step_interval = 0.6 

var delta_time : float = 0.0 # make delta global


 
func _input(event):
	
	if event is InputEventScreenDrag:
		var look_sensitivity = 0.5
		rotate_y(deg_to_rad(-event.relative.x * look_sensitivity))
		$head.rotate_x(deg_to_rad(-event.relative.y * look_sensitivity))
		
		var head_rotation = $head.rotation_degrees
		head_rotation.x -= event.relative.y * look_sensitivity
		head_rotation.x = clamp(head_rotation.x, -90, 90)
		$head.rotation_degrees = head_rotation
		
func _physics_process(delta_time):

	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta_time
		is_on_air = true 
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#adding inertia to gravity
	if is_on_floor():
		if is_on_air:
			jumplanding_sound.play()
			jumplanding_sound.volume_db = -30
			
			#reset
			is_on_air = false	
		
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			# Play footstep sound
			footstep(delta_time)
		
		else:
			#fix the movement momentum when we stop moving, the character stops in a weird manner with no momentum
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta_time  * 7.0)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta_time  * 7.0)
	else:
		#inertia
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta_time  * 3.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta_time  * 3.0)
		
	#head bobbing
	t_bob += delta_time  * velocity.length() * float(is_on_floor())
	$head.transform.origin = _headbob(t_bob)
	
	#fov
	var velocity_clamped = clamp(velocity.length(), 0.5, running_speed * 2)
	var target_fov = base_fov + fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta_time  * 8.0)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amplitude
	pos.x = sin(time * bob_frequency / 2) * bob_amplitude
	return pos
		
func footstep(delta_time ):

	
	time_since_step += delta_time 
	if time_since_step >= step_interval:
		footstep_sound.pitch_scale = randf() * 0.2 + 0.9
		footstep_sound.play()
		time_since_step = 0.0

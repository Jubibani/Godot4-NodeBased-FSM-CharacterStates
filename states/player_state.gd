class_name PlayerState extends State


#basic movements
const Standing = "Standing"
const StandCrouching = "StandCrouching"
const ProneCrouching = "ProneCrouching"
const Proning = "Proning"
const Running = "Running"
const Jumping = "Jumping"

#static var crouching : bool = false

static var crouchingFromStand : bool = false
static var crouchingFromProne : bool = false
static var proning : bool = false

#Speed Values
const crouching_speed = 2.3
const walking_speed = 5.5
const running_speed = 12.5

#feature movements
const WallBounce = "WallBounce"
const Sliding = "sliding"

#for debugging
#var display_output = "crouching: %s, proning: %s" % [str(crouching), str(proning)]



var CharacterPlayer : CharacterBody3D

func _ready() -> void:
	await owner.ready
	CharacterPlayer = owner as CharacterBody3D    
	assert(CharacterPlayer != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.") 

extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
var motion = Vector2.ZERO # Used to store the velocity that the player is traveling at

# Player movement variables
export var speed = 250


# Handles all player motion logic
func player_movement():
	var verticalMovement = Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up")
	var horizontalMovement = Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left")
	
	# Set velocity to the movement variables and normalize the result
	motion = Vector2(horizontalMovement, verticalMovement)
	#motion = motion.normalized()
	
	#print(motion)
	if motion.x == 1:
		sprite.rotation = deg2rad(4)
	elif motion.x == -1:
		sprite.rotation = deg2rad(-4)
	else:
		sprite.rotation = deg2rad(0)
	motion = move_and_slide(motion * speed, Vector2.UP)
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# Call player movement function every frame
	player_movement()


func _on_Hurtbox_body_entered(_body):
	MicrogameJamController.LoseGame()

extends KinematicBody2D


var motion = Vector2.ZERO

var rng = RandomNumberGenerator.new() # Used for random number ganeration
var randomizeSpeed : bool = true

# Movement variables
export var speed : float = 275




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



func _projectile_movement():
	# Since this is an area node, we do not have move and slide, so increment the actual position of the object
	motion = Vector2(speed,0).rotated(rotation)
	motion = move_and_slide(motion)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	_projectile_movement()


# If the paint goes off screen, remove the game object
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 300

# Paint drop reference
onready var paintDrop = preload("res://Enemy_Projectiles/PaintDrop.tscn")

onready var sprite = $Sprite
onready var spawnPosition = $Sprite/Position2D

var centerCoords = Vector2(480, 326.5)

var reveal : bool = true

var threeSpread : bool = false

var brushLifetime = 2



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Rotate the brush to look at the center of the camera
	rotation = (centerCoords - global_position).angle() - deg2rad(90)
	
	# Appear into view
	set_process(true)
	$Sounds/Whoosh.play()


func set_forward_speed():
	speed = abs(speed)


func set_backward_speed():
	speed = -abs(speed)


func spawn_paint():
	var drop = paintDrop.instance()
	drop.rotation = rotation - deg2rad(270)
	drop.global_position = spawnPosition.global_position
	get_parent().add_child(drop)
	
	$Sounds/Splat.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	velocity = Vector2(speed,0).rotated(rotation - deg2rad(270))
	var _motion = move_and_slide(velocity)


func _on_Reveal_Timer_timeout() -> void:
	if reveal:
		spawn_paint()
		reveal = false
		set_process(false)
		set_backward_speed()
		set_process(true)
		$Reveal_Timer.start()
	else:
		queue_free()

extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 300

# Paint drop reference
onready var paintDropGreen = preload("res://Enemy_Projectiles/PaintDrop.tscn")
onready var paintDropYellow = preload("res://Enemy_Projectiles/PaintDrop_Yellow.tscn")
onready var paintDropBlue = preload("res://Enemy_Projectiles/PaintDrop_Blue.tscn")

onready var sprite = $Sprite
onready var spawnPosition = $Sprite/Position2D

var centerCoords = Vector2(480, 326.5)

var reveal : bool = true

var threeSpread : bool = false

var brushLifetime = 2

var rng = RandomNumberGenerator.new()

onready var greenBrush = preload("res://Brush/Brush_Green.png")
onready var yellowBrush = preload("res://Brush/Brush_Yellow.png")
onready var blueBrush = preload("res://Brush/Brush_Blue.png")

var currentColor

enum Colors {
	Green
	Yellow
	Blue
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the texture to be a random color
	rng.randomize()
	
	currentColor = rng.randi_range(0, 2)
	match currentColor:
		Colors.Green:
			sprite.texture = greenBrush
		Colors.Yellow:
			sprite.texture = yellowBrush
		Colors.Blue:
			sprite.texture = blueBrush
	
	
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
	var drop
	# Set its colored texture
	match currentColor:
		Colors.Green:
			drop = paintDropGreen.instance()
		Colors.Yellow:
			drop = paintDropYellow.instance()
		Colors.Blue:
			drop = paintDropBlue.instance()
	
	
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

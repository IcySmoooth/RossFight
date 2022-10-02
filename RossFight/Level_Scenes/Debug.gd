extends Node2D


# Microgame specific Variables
var introTime = 1.6
var winSoundTime = 1.1
export var maxTime : float =  10 # The amount of time that the game lasts
export var difficulty : int        # The current difficulty of the microgame

## Variables for spawning paint drops ##
onready var brush = preload("res://Brush/Brush.tscn")


# Paint drop container
onready var paintDropContainer = $Paintdrop_Container

onready var paintSpawnTimer = $Paint_Spawn_Timer

var paintDropFrequency = 1 # Determines how often (in seconds) to drop paint drops
var maxBrushes : int = 1

var rng = RandomNumberGenerator.new() # Used for random number ganeration

enum sides {
	Top
	Bottom
	Left
	Right
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MicrogameJamController.dev_difficulty = 3
	MicrogameJamController.SetMaxTimer(maxTime + introTime + winSoundTime)
	difficulty = MicrogameJamController.GetDifficulty()
	maxBrushes = difficulty
	
	paintSpawnTimer.wait_time = paintDropFrequency
	


func start_BGM():
	$BGM.play()


func get_brush_coords() -> Vector2:
	var coordinates = Vector2.ZERO
	
	rng.randomize()
	
	# Choose a side to spawn in
	match rng.randi_range(0, 3):
		sides.Top:
			#print("top")
			# Pick a random y coordinate
			rng.randomize()
			coordinates = Vector2(rng.randf_range(41, 512), 12)
		sides.Bottom:
			#print("bottom")
			# Pick a random y coordinate
			rng.randomize()
			coordinates = Vector2(rng.randf_range(41, 512), 623)
		sides.Left:
			#print("left")
			# Pick a random y coordinate
			rng.randomize()
			#coordinates = Vector2(7, rng.randf_range(25, 936))
			coordinates = Vector2(-5, rng.randf_range(41, 512))
		sides.Right:
			#print("right")
			# Pick a random y coordinate
			rng.randomize()
			coordinates = Vector2(956, rng.randf_range(41, 512))
	
	return coordinates


func spawn_brush():
	# Create paint drop instance and spawn it in the random position
	for _i in range(maxBrushes):
		var coords = get_brush_coords()
		#print(coords)
		var brushNode = brush.instance()
		brushNode.global_position = coords
		paintDropContainer.add_child(brushNode)
	
	paintSpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Set label text as the time rounded to the nearest hundreths
	#$Label.text = String(stepify(MicrogameJamController.GetTimer(), 0.01))
	#$Label.text = String(MicrogameJamController.GetTimer())
	
	# Check when the 
	if MicrogameJamController.GetTimer() <= winSoundTime:
		paintDropContainer.free()
		paintSpawnTimer.stop()
		#paintDropContainer.queue_free()
		$WinScreen/WinSound.play()
		set_process(false)


func _on_Paint_Spawn_Timer_timeout() -> void:
	spawn_brush()


func _on_AnimationPlayer_animation_finished(_anim_name):
	spawn_brush()


func _on_WinSound_finished() -> void:
	yield(get_tree().create_timer(.1), "timeout")
	MicrogameJamController.WinGame()

extends Node2D

## Preload Paths
const PipePairScene = preload("res://Scenes/pipe_pair.tscn")

## Pipe Spawn Settings
const PIPE_SPAWN_X = 520.0 			# Spawn outside game view (right)
const GAP_MIN_Y = 150.0				# highest the gap can exist from top
const GAP_MAX_Y = 520.0				# lowest gap can exist from top
const BASE_PIPE_SPEED = 200.0 		# base speed

## Game State
var game_started: bool = false		# true after first jump
var game_over: bool = false			# true when player collides with pipe
var score: int = 0					# round score

## Pipe Speed using GameData settings
var pipe_speed: float


func _ready() -> void:
	# determine pipe speed from game data settings and base values
	pipe_speed = BASE_PIPE_SPEED * GameData.pipe_speed
	
	# hooks spawn timer timeout signal to spawn func
	$PipeSpawnTimer.timeout.connect(_on_pipe_spawn_timer_timeout)


func start_game():
	# starts from first jump and begins pipe spawns
	game_started = true
	$PipeSpawnTimer.start()
	
	
func _on_pipe_spawn_timer_timeout():
	# creates new pipe pair with random heights into scene
	var pipe = PipePairScene.instantiate()
	
	# Random Y position for gap 
	var gap_y = randf_range(GAP_MIN_Y, GAP_MAX_Y)
	pipe.position = Vector2(PIPE_SPAWN_X, gap_y)
	
	# sets pipe speed based on game data settings
	pipe.speed = pipe_speed
	
	# hook in score zone to detect when player passes through a score zone
	pipe.get_node("ScoreZone").body_entered.connect(_on_score_zone_entered.bind(pipe))
	
	add_child(pipe)
		
		
func _on_score_zone_entered(body, pipe):
	# count score if pipe has not been scored from 
	if body == $Player and not pipe.scored:
		pipe.scored = true
		score += 1
	
	
func _input(event):
	# allow if game is active
	if event.is_action_pressed("jump") and not game_started and not game_over:
		start_game()
		
		
		

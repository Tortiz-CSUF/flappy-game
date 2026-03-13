extends Node2D

## Preload Paths
const PipePairScene = preload("res://Scenes/pipe_pair.tscn")
const CoinScene = preload("res://coin.tscn")

## Pipe Spawn Settings
const PIPE_SPAWN_X = 520.0 			# Spawn outside game view (right)
const GAP_MIN_Y = 150.0				# highest the gap can exist from top
const GAP_MAX_Y = 520.0				# lowest gap can exist from top
const BASE_PIPE_SPEED = 200.0 		# base speed

## Coin Spawn
const COIN_SPAWN_X = 520.0 
const COIN_MIN_Y = 80.0
const COIN_MAX_Y = 650.0


## Coin Icon Drawing
const COIN_ICON_RADIUS = 10.0
const COIN_ICON_COLOR = Color.GOLD
const COIN_ICON_POINTS = 16

## Ground Drawing consts
const GROUND_COLOR = Color(0.212, 0.353, 0.068, 1.0)
const GROUND_RECT = Rect2(0, 680, 480, 40)

## Game State
var game_started: bool = false		# true after first jump
var game_over: bool = false			# true when player collides with pipe
var score: int = 0					# round score

## Pipe Speed using GameData settings
var pipe_speed: float


func _ready() -> void:
	# determine pipe speed from game data settings and base values
	pipe_speed = BASE_PIPE_SPEED * GameData.pipe_speed
	
	# hooks timers timeout signal to spawn func
	$PipeSpawnTimer.timeout.connect(_on_pipe_spawn_timer_timeout)
	$CoinSpawnTimer.timeout.connect(_on_coin_spawn_timer_timeout)
	
	
	# Display Score
	$ScoreLabel.text = "0"
	
	# Displays collected coin count
	$CoinCountLabel.text = str(GameData.coins)
	
func _draw():
	# draws ground 
	draw_rect(GROUND_RECT, GROUND_COLOR)
	
	# draws icon next to coin count label
	var icon_pos = $CoinIcon.position
	var points = PackedVector2Array()
	
	for i in range(COIN_ICON_POINTS):
		var angle = i * TAU / COIN_ICON_POINTS
		var x = icon_pos.x + cos(angle) * COIN_ICON_RADIUS
		var y = icon_pos.y + sin(angle) * COIN_ICON_RADIUS
		points.append(Vector2(x, y))
	
	draw_colored_polygon(points, COIN_ICON_COLOR)
	

func start_game():
	# starts from first jump and begins pipe spawns and coins spawns
	game_started = true
	$PipeSpawnTimer.start()
	$CoinSpawnTimer.start()
	
	
func _on_pipe_spawn_timer_timeout():
	print("Pipe Spawning...")
	
	# creates new pipe pair with random heights into scene
	var pipe = PipePairScene.instantiate()
	pipe.add_to_group("pipes")
	
	# Random Y position for gap 
	var gap_y = randf_range(GAP_MIN_Y, GAP_MAX_Y)
	pipe.position = Vector2(PIPE_SPAWN_X, gap_y)
	
	# sets pipe speed based on game data settings
	pipe.speed = pipe_speed
	
	# hook in score zone to detect when player passes through a score zone
	pipe.get_node("ScoreZone").body_entered.connect(_on_score_zone_entered.bind(pipe))
	
	add_child(pipe)
	
func _on_coin_spawn_timer_timeout():
	# spawn coins at random pos
	var coin = CoinScene.instantiate()
	var coin_y = randf_range(COIN_MIN_Y, COIN_MAX_Y)
	var coin_x = COIN_SPAWN_X
	
	# checks all existing pipes for proper positioning
	for child in get_children():
		if child.is_in_group("pipes"):
			var distance_x = abs(coin_x - child.position.x)
			if distance_x < 100:
				coin_y = child.position.y + randf_range(-50, 50)
			
	coin.position = Vector2(coin_x, coin_y)	
	
	# match pipe move speed
	coin.speed = pipe_speed
	add_child(coin)
		
		
func _on_score_zone_entered(body, pipe):
	# count score if pipe has not been scored from 
	if body == $Player and not pipe.scored:
		pipe.scored = true
		score += 1
	
	
func _input(event):
	# allow if game is active
	if event.is_action_pressed("jump") and not game_started and not game_over:
		start_game()

func _process(_delta):
	# updates coin count label
	$CoinCountLabel.text = str(GameData.coins)
		
		

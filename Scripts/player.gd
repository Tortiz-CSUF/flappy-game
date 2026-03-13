extends CharacterBody2D


## Physics const vars
const BASE_GRAVITY = 900.0			# gravity 
const BASE_JUMP_SPEED = -350.0		# Upward jump

## Rotation Effect Const
const MAX_ROTATION = PI / 2
const JUMP_ROTATION = -PI / 6
const ROTATION_SPEED = 2.5

## Dimensional vals
const OVAL_WIDTH = 50.0
const OVAL_HEIGHT = 34.0
const OVAL_POINTS = 32				# polygon points for ellipses

# Physics vals: bae * GameData settings
var gravity: float
var jump_speed: float

# State flags
var is_dead: bool = false
var game_active: bool = false		# true when player first jumps

func _ready():
	# apply players settings at main menu runtime
	gravity = BASE_GRAVITY * GameData.gravity_scale
	jump_speed = BASE_JUMP_SPEED * GameData.jump_height
	
func _draw():
	# draws a ellipse at player position and draws points around it. 
	var points = PackedVector2Array()
	
	for i in range(OVAL_POINTS):
		var angle = i * TAU / OVAL_POINTS
		var x = cos(angle) * OVAL_WIDTH / 2.0
		var y = sin(angle) * OVAL_HEIGHT / 2.0
		points.append(Vector2(x, y))
	
	draw_colored_polygon(points, GameData.get_player_color())	


func _physics_process(delta: float) -> void:
	# if player dead: stop movement
	if is_dead or not game_active:
		return
		
	# apply gravity. velocity increases to create acceleration.
	velocity.y += gravity * delta
	
	# rotate clockwise when falling
	if velocity.y > 0:
		rotation = min(rotation + ROTATION_SPEED * delta, MAX_ROTATION)
		
	move_and_slide()

func _input(event):
	# if player dead: ignore input
	if is_dead:
		return
		
	# Jumps using spacebar
	if event.is_action_pressed("jump"):
		jump()	
	
func jump():	
	# activates player on first jump
	game_active = true
	
	# sets up velo and tilt's the player character upward
	velocity.y = jump_speed
	rotation = JUMP_ROTATION
	
	# case: color needs update -> redraw shape
	queue_redraw()
	
	

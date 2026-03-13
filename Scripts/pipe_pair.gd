extends Node2D

# Pipe Drawing consts
const PIPE_WIDTH = 80.0 			# pipe width
const PIPE_HEIGHT = 720.0			# pipe height
const PIPE_COLOR = Color.GREEN		# pipe color

# Pipe Movement Speed
var speed: float = 200.0

# State Flags
var scored: bool = false			# tracks if pipe was cleared = +1 score
var is_active: bool = true			# bool if pipes should be moving

func _draw():
	print("Drawing pipe at: ", position)
	
	# draws top pipe (centered)
	var top_y = $TopPipe/TopCollision.position.y
	draw_rect(Rect2(-PIPE_WIDTH / 2, top_y - PIPE_HEIGHT / 2, PIPE_WIDTH, PIPE_HEIGHT), PIPE_COLOR)
	
	# draws bottom pipe (centered)
	var bottom_y = $BottomPipe/BottomCollision.position.y
	draw_rect(Rect2(-PIPE_WIDTH / 2, bottom_y - PIPE_HEIGHT / 2, PIPE_WIDTH, PIPE_HEIGHT), PIPE_COLOR)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# only allows moevment if game is active 
	if not is_active:
		return
		
	# moves pipe pairs towards left
	position.x -= speed * delta
	
	# removes pipe pair once its out of game view
	if position.x < -100:
		queue_free()

## used externally when player dies to stop all pipe movement
func stop():
	is_active = false                               

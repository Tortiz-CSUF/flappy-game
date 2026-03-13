extends Area2D

## Coins Drawing consts
const COIN_RADIUS = 12.0 
const COIN_COLOR = Color.GOLD
const COIN_POINTS = 24


func _ready() -> void:
	# hooks in from main
	body_entered.connect(_on_body_entered)


func _draw():
	# draw golden circle (coins)
	var points = PackedVector2Array()
	
	for i in range(COIN_POINTS):
		var angle = i * TAU / COIN_POINTS
		var x = cos(angle) * COIN_RADIUS
		var y = sin(angle) * COIN_RADIUS
		points.append(Vector2(x, y))
	
	draw_colored_polygon(points, COIN_COLOR)
	
	
func _on_body_entered(body):
	# reacts to player
	if body.name == "Player":
		#award random coin val
		var coin_value = randi_range(1, 5)
		GameData.coins += coin_value
		#save coins to file
		GameData.save_data()
		#remove coins from scene
		
		
		queue_free()

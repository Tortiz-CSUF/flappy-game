extends Node2D

## Sky Draw vals
const SKY_TOP_CPLOR = Color(0.7, 0.9, 1.0)
const SKY_BOTTOM_COLOR = Color(0.7, 0.9, 1.0)

## Cloud Settings
const CLOUD_MIN_Y = 50.0 
const CLOUD_MAX_Y = 600.0
const CLOUD_SPEED = 60.0
const CLOUD_WIDTH = 100.0
const CLOUD_HEIGHT = 60.0
const CLOUD_POINTS = 24

## Player Preview
const OVAL_WIDTH = 50.0
const OVAL_HEIGHT = 34.0
const OVAL_POINTS = 32

## Coin Icon
const COIN_ICON_RADIUS = 20.0
const COIN_ICON_COLOR = Color.GOLD
const COIN_ICON_POINTS = 16

## Settings Steps
const SETTING_STEP = 0.1
const SETTING_MIN = 0.5
const SETTING_MAX = 2.0

## Holds cloud pos
var clouds: Array = []


func _ready() -> void:
	# shows saved high score and coin count
	$HighScoreLabel.text = "High Score: " + str(GameData.high_score)
	$CoinCountLabel.text = str(GameData.coins)
	
	# shows current settings vals
	update_settings_labels()
	
	# connects cloud spawn timer and settings buttons
	$CloudTimer.timeout.connect(_on_cloud_timer_timeout)
	$StartButton.pressed.connect(_on_start_pressed)
	$GravityDownButton.pressed.connect(_on_gravity_down)
	$GravityUpButton.pressed.connect(_on_gravity_up)
	$JumpDownButton.pressed.connect(_on_jump_down)
	$JumpUpButton.pressed.connect(_on_jump_up)
	$SpeedDownButton.pressed.connect(_on_speed_down)
	$SpeedUpButton.pressed.connect(_on_speed_up)
	$ColorDownButton.pressed.connect(_on_color_down)
	$ColorUpButton.pressed.connect(_on_color_up)
	
	# spawn initial clouds at load
	for i in range(5):
		clouds.append(Vector2(randf_range(0, 480), randf_range(CLOUD_MIN_Y, CLOUD_MAX_Y)))
	
func _draw():
	# draw sky
	draw_rect(Rect2(0, 0, 480, 360), SKY_TOP_CPLOR)
	draw_rect(Rect2(0, 360, 480, 360), SKY_BOTTOM_COLOR)
	
	# draw clouds
	for cloud_pos in clouds:
		var points = PackedVector2Array()
		for i in range(CLOUD_POINTS):
			var angle = i * TAU / CLOUD_POINTS
			var x = cloud_pos.x + cos(angle) * CLOUD_WIDTH / 2.0
			var y = cloud_pos.y + sin(angle) * CLOUD_HEIGHT / 2.0
			points.append(Vector2(x, y))
			
		draw_colored_polygon(points, Color.WHITE)
		
	# draw coin icon
	var icon_pos = $CoinIcon.position
	var coin_points = PackedVector2Array()
	for i in range(COIN_ICON_POINTS):
		var angle = i * TAU / COIN_ICON_POINTS
		var x = icon_pos.x + cos(angle) * COIN_ICON_RADIUS / 2.0
		var y = icon_pos.y + sin(angle) * COIN_ICON_RADIUS / 2.0
		coin_points.append(Vector2(x, y))
		
	draw_colored_polygon(coin_points, COIN_ICON_COLOR)
	
	# Draw player preview
	var preview_pos = $PlayerPreview.position
	var oval_points = PackedVector2Array()
	for i in range(OVAL_POINTS):
		var angle = i * TAU / OVAL_POINTS
		var x = preview_pos.x + cos(angle) * OVAL_WIDTH / 2.0
		var y = preview_pos.y + sin(angle) * OVAL_HEIGHT / 2.0
		oval_points.append(Vector2(x, y))
		
	draw_colored_polygon(oval_points, GameData.get_player_color())
		
	
func _process(delta: float) -> void:
	# moves all clouds toward left
	for i in range(clouds.size() -1, -1, -1):
		clouds[i].x -= CLOUD_SPEED * delta
		if clouds[i].x < -CLOUD_WIDTH:
			clouds.remove_at(i)
			
	queue_redraw()
		
		
	
func _on_cloud_timer_timeout():
	# spawn new clouds
	clouds.append(Vector2(480 + CLOUD_WIDTH, randf_range(CLOUD_MIN_Y, CLOUD_MAX_Y)))
	
	
func _on_start_pressed():
	# saves settings before loading scene
	GameData.save_data()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	

## Gravity settings
func _on_gravity_down():
	GameData.gravity_scale = max(SETTING_MIN, GameData.gravity_scale - SETTING_STEP)
	update_settings_labels()
		

func _on_gravity_up():
	GameData.gravity_scale = min(SETTING_MAX, GameData.gravity_scale + SETTING_STEP)
	update_settings_labels()
		

## Jump Settings		
func _on_jump_down():
	GameData.jump_height = max(SETTING_MIN, GameData.jump_height - SETTING_STEP)
	update_settings_labels()
	

func _on_jump_up():
	GameData.jump_height = min(SETTING_MAX, GameData.jump_height + SETTING_STEP)
	update_settings_labels()
				
		
## Speed Settings
func _on_speed_down():
	GameData.pipe_speed = max(SETTING_MIN, GameData.pipe_speed - SETTING_STEP)
	update_settings_labels()
	

func _on_speed_up():
	GameData.pipe_speed = min(SETTING_MAX, GameData.pipe_speed + SETTING_STEP)
	update_settings_labels()
	
	
## Color Selector
func _on_color_down():
	GameData.player_color_index -= 1
	if GameData.player_color_index < 0:
		GameData.player_color_index = GameData.player_colors.size()	 - 1
		
		
func _on_color_up():
	GameData.player_color_index += 1
	if GameData.player_color_index >= GameData.player_colors.size():
		GameData.player_color_index = 0
		
## Helper: updates labels for settings
func update_settings_labels():		
	$GravityLabel.text = "Gravity: " + str(snapped(GameData.gravity_scale, 0.1))
	$JumpLabel.text = "Jump: " +str(snapped(GameData.jump_height, 0.1))
	$SpeedLabel.text = "Speed: " + str(snapped(GameData.pipe_speed, 0.1))
	
		

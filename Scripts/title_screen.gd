extends Node2D

## Sky Draw vals
const SKY_TOP_CPLOR = Color(0.4, 0.7, 1.0)
const SKY_BOTTOM_COLOR = Color(0.7, 0.9, 1.0)

## Cloud Settings
const CLOUD_MIN_Y = 50.0 
const CLOUD_MAX_Y = 600.0
const CLOUD_SPEED = 60.0
const CLOUD_WIDTH = 80.0
const CLOUD_HEIGHT = 30.0
const CLOUD_POINTS = 24

## Player Preview
const OVAL_WIDTH = 50.0
const OVAL_HEIGHT = 34.0
const OVAL_POINTS = 32

## Coin Icon
const COIN_ICON_RADIUS = 10.0
const COIN_ICON_COLOR = Color.GOLD
const COIN_ICON_POINTS = 16

## Settings Steps
const SETTING_STEP = 0.1
const SETTING_MIN = 0.5
const SETTING_MAX = 2.0

## Holds cloud pos
var clouds: Array = []


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	# moves all clouds toward left
	for i in range(clouds.size()):
		clouds[i].x -= CLOUD_SPEED * delta
		
		#destroy clouds when out of gam view
		var new_clouds: Array = []
		for cloud_pos in clouds:
			if cloud_pos.x > -CLOUD_WIDTH:
				new_clouds.append(cloud_pos)
				
		clouds = new_clouds
		
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
	GameData.jump_height = min(SETTING_MIN, GameData.jump_height + SETTING_STEP)
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
	
		

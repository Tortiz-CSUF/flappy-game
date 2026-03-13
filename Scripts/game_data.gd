extends Node

# Constant vars
const SAVE_PATH = "user://save_data.cfg"		# File path for player save data

# State vars
var high_score: int = 0
var coins: int = 0
var gravity_scale: float = 1.0
var jump_height: float = 1.0
var pipe_speed: float = 1.0
var player_color_index: int = 0

# Array holding player available colors
var player_colors: Array = [
	Color.RED,
	Color.ORANGE,
	Color.YELLOW,
	Color.GREEN,
	Color.CYAN,
	Color.BLUE,
	Color.PURPLE,
	Color.HOT_PINK
]

func _ready() -> void:
	load_data()

func get_player_color() -> Color:
	return player_colors[player_color_index]

# saves all data
func save_data():
	var config = ConfigFile.new()
	
	config.set_value("data", "high_score", high_score)
	config.set_value("data", "coins", coins)
	config.set_value("data", "gravity_scale", gravity_scale)
	config.set_value("data", "jump_height", jump_height)
	config.set_value("data", "pipe_speed", pipe_speed)
	config.set_value("data", "player_color_index", player_color_index)
	config.save(SAVE_PATH)
	
# loads all saved data 
func load_data():
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	if err != OK:
		return
	
	high_score = config.get_value("data", "high_score", 0)
	coins = config.get_value("data", "coins", coins)
	gravity_scale = config.get_value("data", "gravity_scale", gravity_scale)
	jump_height = config.get_value("data", "jump_height", jump_height)
	pipe_speed = config.get_value("data", "pipe_speed", pipe_speed)
	player_color_index = config.get_value("data", "player_color_index", player_color_index)

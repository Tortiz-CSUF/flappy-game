extends Node


func _ready() -> void:
	# makes sure music is playing 
	if not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()

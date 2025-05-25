extends TextureRect

@onready var video_stream_player: VideoStreamPlayer = $"../../SubViewport/VideoStreamPlayer"
var video_pressed: bool = false

func _input(event):
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		if event is InputEventScreenTouch and event.pressed:
			video_pressed = true
	else:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			video_pressed = true
	
	if video_pressed: 
		video_pressed = false
		video_stream_player.paused = not video_stream_player.paused
		

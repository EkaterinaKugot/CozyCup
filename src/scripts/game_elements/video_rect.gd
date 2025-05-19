extends TextureRect

@onready var video_stream_player: VideoStreamPlayer = $"../../SubViewport/VideoStreamPlayer"

func _input(event):
	if (event is InputEventScreenTouch and event.pressed) or \
	(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		video_stream_player.paused = not video_stream_player.paused

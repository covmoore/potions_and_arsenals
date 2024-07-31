extends AudioStreamPlayer

@onready var audioStreamPlayer = $"."
var cur_index = 0
var songs = [preload("res://audio/music/fight_with_gusto.wav"), preload("res://audio/music/main_theme.wav")]

# Called when the node enters the scene tree for the first time.
func _ready():
	play_track(cur_index)


func play_track(index):
	audioStreamPlayer.stream = songs[index]
	audioStreamPlayer.play()


func _on_finished():
	if(cur_index == songs.size() -1):
		cur_index = 0
	else:
		cur_index += 1
	play_track((cur_index))

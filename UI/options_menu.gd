extends Control
@onready var MASTER_VOLUME_ID = AudioServer.get_bus_index("Master")
@onready var SFX_VOLUME_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_VOLUME_ID = AudioServer.get_bus_index("Music")

@onready var master_slider = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/masterSlider
@onready var sfx_slider = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer2/fxSlider
@onready var music_slider = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer3/musicSlider


signal closePanel
# Called when the node enters the scene tree for the first time.
func _ready():
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(MASTER_VOLUME_ID))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(SFX_VOLUME_ID))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_VOLUME_ID))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_btn_pressed():
	emit_signal("closePanel")


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_VOLUME_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_VOLUME_ID, value < 0.05)


func _on_fx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_VOLUME_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_VOLUME_ID, value < 0.05)


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MASTER_VOLUME_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MASTER_VOLUME_ID, value < 0.05)

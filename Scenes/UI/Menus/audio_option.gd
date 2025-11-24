extends Control

@onready var music_slider: HSlider = $CenterContainer/VBoxContainer/MusicSlider
@onready var sound_effect_slider: HSlider = $CenterContainer/VBoxContainer/SoundEffectSlider


func _ready() -> void:
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	sound_effect_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))


func _on_music_slider_drag_ended(_value_changed: bool) -> void:
	music_slider.release_focus()

func _on_sound_effect_slider_drag_ended(_value_changed: bool) -> void:
	sound_effect_slider.release_focus()

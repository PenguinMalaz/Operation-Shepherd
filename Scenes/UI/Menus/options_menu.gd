extends CanvasLayer

@onready var music_slider: HSlider = $AudioOption/CenterContainer/VBoxContainer/MusicSlider
@onready var sound_effect_slider: HSlider = $AudioOption/CenterContainer/VBoxContainer/SoundEffectSlider

var on_level: bool = false

func _ready() -> void:
	GlobalVariable.game_sound = true

func _process(_delta: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(music_slider.value))
	AudioServer.set_bus_volume_db(2, linear_to_db(sound_effect_slider.value))

func _on_sound_effect_slider_drag_ended(_value_changed: bool) -> void:
	SoundEffect.flip()

func _on_back_pressed() -> void:
	if !on_level:
		$Fade.fade("res://Scenes/UI/MainMenu/MainMenu.tscn")
	else:
		$Fade.fade_add_or_delete_scene("res://Scenes/UI/Menus/options_menu.tscn", "queue_free")
	SoundEffect.pressed()
	
func _on_back_mouse_entered() -> void:
	SoundEffect.hover()

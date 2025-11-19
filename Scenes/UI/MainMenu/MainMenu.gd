extends Control

@onready var fade: CanvasLayer = $Fade

func _ready() -> void:
	if not Music.is_playing_mainmenu():
		Music.play_main_menu()
	
	Music.stop_gameplay()
	Music.stop_investigation()

## Play button pressed
func _on_play_pressed() -> void:
	fade.fade("res://Scenes/Levels/LevelSelection.tscn")
	SoundEffect.pressed()

## Credit button Pressed
func _on_credits_pressed() -> void:
	fade.fade("res://Scenes/Credits/Credits.tscn")
	SoundEffect.pressed()

## Quit button pressed
func _on_quit_pressed() -> void:
	get_tree().quit()
	SoundEffect.pressed()

## Play button hover
func _on_play_mouse_entered() -> void:
	SoundEffect.hover()

## Credit button hover
func _on_credits_mouse_entered() -> void:
	SoundEffect.hover()

## Quit button Hover
func _on_quit_mouse_entered() -> void:
	SoundEffect.hover()

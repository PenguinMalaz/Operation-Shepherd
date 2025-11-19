extends Control

@onready var fade: CanvasLayer = $Fade

## Back button pressed
func _on_back_button_down() -> void:
	fade.fade("res://Scenes/UI/MainMenu/MainMenu.tscn")
	SoundEffect.pressed()

## Back button hover
func _on_back_mouse_entered() -> void:
	SoundEffect.hover()

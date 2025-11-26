extends CanvasLayer

signal resume

func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()
	GlobalVariable.cursor = false
	SoundEffect.pressed()
	emit_signal("resume")

func _on_settings_pressed() -> void:
	$Fade.fade_add_or_delete_scene("res://Scenes/UI/Menus/options_menu.tscn", "instance")
	SoundEffect.pressed()

func _on_main_menu_pressed() -> void:
	$Fade.fade("res://Scenes/UI/MainMenu/MainMenu.tscn")
	SoundEffect.pressed()


func _on_resume_mouse_entered() -> void:
	SoundEffect.hover()


func _on_settings_mouse_entered() -> void:
	SoundEffect.hover()


func _on_main_menu_mouse_entered() -> void:
	SoundEffect.hover()

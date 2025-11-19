extends CanvasLayer


func _on_close_button_down() -> void:
	$Info.visible = false
	SoundEffect.pressed()


func _on_close_mouse_entered() -> void:
	SoundEffect.hover()

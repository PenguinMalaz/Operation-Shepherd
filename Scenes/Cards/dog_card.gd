extends CanvasLayer

signal dog_mode(active: bool)

@onready var card_sprite: AnimatedSprite2D = $"Dog Card/Dialogue/Button/Sprite2D"

var pressed: bool = false

func _on_button_pressed() -> void:
	pressed = !pressed
	SoundEffect.pressed()
	if pressed:
		card_sprite.frame = 2
		card_sprite.scale = Vector2(1.3, 1.3)
		emit_signal("dog_mode", true)
		SoundEffect.bark()
	else:
		card_sprite.frame = 1
		card_sprite.scale = Vector2(1.2, 1.2)
		emit_signal("dog_mode", false)


func _on_button_mouse_entered() -> void:
	if !$"Dog Card/Dialogue/Button".disabled:
		if !pressed:
			card_sprite.frame = 1
		SoundEffect.hover()


func _on_button_mouse_exited() -> void:
	if !$"Dog Card/Dialogue/Button".disabled:
		if !pressed:
			card_sprite.frame = 0

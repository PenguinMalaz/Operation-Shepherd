extends CanvasLayer

signal elimination_active

signal button_pressed

# Untuk mengeliminasi kartu
var investigation_active: bool = false
var elimination: bool = false
var button_hover: bool = false
var dog_mode: bool = false

func _ready() -> void:
	investigation_active = false


func _process(_delta: float) -> void:
	if elimination:
		$Button/AnimatedSprite2D.frame = 2
	else:
		if button_hover == true:
			$Button/AnimatedSprite2D.frame = 1
		else:
			$Button/AnimatedSprite2D.frame = 0
	

func _on_button_button_down() -> void:
	# Toggle nilai antara true dan false
	elimination = not elimination
	SoundEffect.reload_()
	emit_signal("button_pressed")
	
	if elimination:
		# Jika Investigation diaktifkan
		Music.stop_gameplay()
		Music.play_investigation()
		emit_signal("elimination_active")
		
	else:
		# Jika Investigation dibatalkan (dimatikan)
		Music.stop_investigation()
		Music.play_gameplay()
		
		

func _on_button_mouse_entered() -> void:
	if !dog_mode:
		SoundEffect.hover()
		$Button/AnimatedSprite2D.frame = 1
		button_hover = true

func _on_button_mouse_exited() -> void:
	if !dog_mode:
		$Button/AnimatedSprite2D.frame = 0
		button_hover = false

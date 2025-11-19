extends CanvasLayer

# Untuk mengeliminasi kartu
var investigation_active: bool = false
var button_hover: bool = false

func _ready() -> void:
	
	investigation_active = false 
	
	


func _process(_delta: float) -> void:
	if investigation_active:
		$Button/AnimatedSprite2D.frame = 2
	else:
		if button_hover == true:
			$Button/AnimatedSprite2D.frame = 1
		else:
			$Button/AnimatedSprite2D.frame = 0

func _on_button_button_down() -> void:
	# Toggle nilai antara true dan false
	investigation_active = not investigation_active
	SoundEffect.pressed()
	
	
	if investigation_active:
		# Jika Investigation diaktifkan
		Music.stop_gameplay()
		Music.play_investigation()
	else:
		# Jika Investigation dibatalkan (dimatikan)
		Music.stop_investigation()
		Music.play_gameplay()

func _on_button_mouse_entered() -> void:
	SoundEffect.hover()
	$Button/AnimatedSprite2D.frame = 1
	button_hover = true

func _on_button_mouse_exited() -> void:
	$Button/AnimatedSprite2D.frame = 0
	button_hover = false

extends Control
class_name LevelSelection

## Scene-scene untuk level
@onready var level_scenes: Array[PackedScene] = GlobalVariable.LEVEL_SCENES
## UI Menu, nanti dipakai lagi ketika keluar dari gameplay
@onready var fade: CanvasLayer = $Fade

# Konstanta warna
const UNLOCKED_COLOR: Color = Color(1, 1, 1, 1)    # Warna normal (putih penuh)
const LOCKED_COLOR: Color = Color(0.5, 0.5, 0.5, 1) # Warna redup (abu-abu)

# Array untuk menyimpan Sprite2D (ikon visual level) dan Button (untuk interaksi)
@onready var level_sprites: Array[Sprite2D] = [
	$"Level 1/Sprite",
	$"Level 2/Sprite",
	$"Level 3/Sprite",
	$"Level 4/Sprite",
	$"Level 5/Sprite"
]
@onready var level_buttons: Array[Button] = [
	$"Level 1" as Button, # Sesuaikan path jika perlu
	$"Level 2" as Button,
	$"Level 3" as Button,
	$"Level 4" as Button,
	$"Level 5" as Button,
]

# --- Implementasi Logic Lock/Unlock dengan Modulate ---

func _ready() -> void:
	# 1. Panggil load_game() terlebih dahulu untuk memuat data level tertinggi yang terbuka
	GlobalVariable.load_game()
	
	Leaves.show()
	
	# 2. Ambil nilai yang sudah dimuat. Nilai ini sekarang adalah level tertinggi yang tersimpan.
	var max_unlocked_level: int = GlobalVariable.unlocked_level
	
	# Loop untuk memeriksa setiap level
	for i in range(level_sprites.size()):
		var level_number: int = i + 1 # Level dimulai dari 1
		
		# Referensi Sprite dan Button saat ini
		var current_sprite: Sprite2D = level_sprites[i]
		var current_button: Button = level_buttons[i]
		
		# Jika level_number lebih kecil atau sama dengan level tertinggi yang dibuka
		if level_number <= max_unlocked_level:
			# BUKA LEVEL
			current_button.disabled = false
			current_sprite.modulate = UNLOCKED_COLOR # Warna normal
			current_button.mouse_filter = Control.MOUSE_FILTER_PASS # Pastikan filter kembali normal
		else:
			# KUNCI LEVEL
			current_button.disabled = true
			current_sprite.modulate = LOCKED_COLOR # Warna redup
			
			# Hentikan semua input terkait mouse/hover untuk tombol yang terkunci
			current_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	
	if not Music.is_playing_mainmenu():
		Music.play_main_menu()
	
	Music.stop_investigation()
	Music.stop_gameplay()


# --- Fungsi Pemicu Level (Menambahkan pengecekan .disabled) ---
func _on_level_1_button_down() -> void:
	level_loader_button_down(0, 1)

func _on_level_2_button_down() -> void:
	level_loader_button_down(1, 2)

func _on_level_3_button_down() -> void:
	level_loader_button_down(2, 3)

func _on_level_4_button_down() -> void:
	level_loader_button_down(3, 4)

func _on_level_5_button_down() -> void:
	level_loader_button_down(4, 5)

func level_loader_button_down(level_button: int, level: int) -> void:
	if not level_buttons[level_button].disabled:
		fade.fade("res://Scenes/Levels/level_" + str(level) + ".tscn")
		SoundEffect.pressed()

# --- Handling Mouse Hover (Mengecek status disabled agar level terkunci tidak scaling) ---
func _on_level_1_mouse_entered() -> void:
	level_mouse_entered(0)

func _on_level_2_mouse_entered() -> void:
	level_mouse_entered(1)

func _on_level_3_mouse_entered() -> void:
	level_mouse_entered(2)

func _on_level_4_mouse_entered() -> void:
	level_mouse_entered(3)

func _on_level_5_mouse_entered() -> void:
	level_mouse_entered(4)

func level_mouse_entered(level_array: int) -> void:
	if not level_buttons[level_array].disabled:
		level_sprites[level_array].scale = Vector2(1.1, 1.1)
		SoundEffect.pops()

func _on_level_1_mouse_exited() -> void:
	level_mouse_exited(0)

func _on_level_2_mouse_exited() -> void:
	level_mouse_exited(1)

func _on_level_3_mouse_exited() -> void:
	level_mouse_exited(2)

func _on_level_4_mouse_exited() -> void:
	level_mouse_exited(3)

func _on_level_5_mouse_exited() -> void:
	level_mouse_exited(4)

func level_mouse_exited(level_array: int) -> void:
	if not level_buttons[level_array].disabled:
		level_sprites[level_array].scale = Vector2(1, 1)

# --- Fungsi Back ---
func _on_back_button_down() -> void:
	fade.fade("res://Scenes/UI/MainMenu/MainMenu.tscn")
	SoundEffect.pressed()


func _on_back_mouse_entered() -> void:
	SoundEffect.hover()

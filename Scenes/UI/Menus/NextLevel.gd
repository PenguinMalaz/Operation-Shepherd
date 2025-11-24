extends CanvasLayer

var go_to_next_level: String = ""

# Export variable untuk di tampilkan di tampilan next level
@export var predator_found: int = 0: # Menggunakan setter untuk memperbarui tampilan saat nilai berubah
	set(value):
		predator_found = value
		update_score_display()
@export var current_heart: int = 0: # Menggunakan setter untuk memperbarui tampilan saat nilai berubah
	set(value):
		current_heart = value
		update_score_display()

# Label text di next level
@onready var Stats: RichTextLabel = $NextLevel/StatPanel/Panel/Stats

@onready var fade: CanvasLayer = $Fade

func _ready() -> void:
	# Panggil di _ready juga untuk menampilkan nilai awal (misalnya 0)
	update_score_display()

# Fungsi untuk memperbarui teks di RichTextLabel
func update_score_display() -> void:
	# **Pengecekan Keamanan**
	if not is_instance_valid(Stats):
		return

	var color_red: String = "#b35054"

	# Menggunakan BBCode untuk mengatur warna
	var text: String = ""
	
	# Predator founded
	text += "Predators founded : [color=" + color_red + "]" + str(predator_found) + "[/color]\n"
	
	# Heart left
	text += "Hearts left : [color=" + color_red + "]" + str(current_heart) + "[/color]"

	Stats.text = text

## Ketika tombol next level ditekan
func _on_next_level_btn_pressed() -> void:
	fade.fade(go_to_next_level)
	SoundEffect.pressed()


func _on_next_level_btn_mouse_entered() -> void:
	SoundEffect.hover()

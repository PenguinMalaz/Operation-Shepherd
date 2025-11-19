extends CanvasLayer

var go_to_next_level: String = ""

# Export variable untuk di tampilkan di tampilan next level
@export var predator_found: int = 0: # Menggunakan setter untuk memperbarui tampilan saat nilai berubah
	set(value):
		predator_found = value
		update_score_display()
@export var total_score: int = 0: # Menggunakan setter untuk memperbarui tampilan saat nilai berubah
	set(value):
		total_score = value
		update_score_display()
@export var current_heart: int = 0: # Menggunakan setter untuk memperbarui tampilan saat nilai berubah
	set(value):
		current_heart = value
		update_score_display()

# Label text di next level
@onready var Score: RichTextLabel = $NextLevel/StatPanel/Panel/Score

@onready var fade: CanvasLayer = $Fade

func _ready() -> void:
	# Panggil di _ready juga untuk menampilkan nilai awal (misalnya 0)
	update_score_display()

# Fungsi untuk memperbarui teks di RichTextLabel
func update_score_display() -> void:
	# **Pengecekan Keamanan**
	if not is_instance_valid(Score):
		return

	var color_red: String = "#b35054"
	var color_green: String = "#a7d694"

	# Menggunakan BBCode untuk mengatur warna
	var text: String = ""
	
	# Predator founded (Angka Merah)
	# Tag [/color] diletakkan tepat setelah str(predator_found)
	text += "Predator ditemukan : [color=" + color_red + "]" + str(predator_found) + "[/color]\n"
	
	# Score (Angka Hijau)
	# Tag [/color] diletakkan tepat setelah str(total_score)
	text += "Score : [color=" + color_green + "]" + str(total_score) + "[/color]\n"
	
	# Heart (Angka Merah)
	# Tag [/color] diletakkan tepat setelah str(current_heart)
	text += "Sisa nyawa : [color=" + color_red + "]" + str(current_heart) + "[/color]"

	Score.text = text

## Ketika tombol next level ditekan
func _on_next_level_btn_pressed() -> void:
	fade.fade(go_to_next_level)
	SoundEffect.pressed()


func _on_next_level_btn_mouse_entered() -> void:
	SoundEffect.hover()

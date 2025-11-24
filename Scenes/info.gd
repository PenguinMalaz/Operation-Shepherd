extends CanvasLayer

signal animation_info_finish

# Variabel untuk menyimpan array dialog
var dialogue: Array = [
	"Pengembala!, seekor domba telah ditemukan mati seperti dimakan oleh predator, tetapi aku tidak melihat adanya predator",
	"Kemungkinan para predator menyamar di antara kawanan domba",
	"Kita harus menemukan predatornya dengan cara memberikan kartu yang bergambarkan benda kepada para domba",
	"Hanya domba saja yang bisa mendeskripsikan dengan benar tentang gambar yang ada di kartu",
	"Jika ada domba yang tidak bisa mendeskripsikannya kemungkinan itu adalah predator"
]

# Variabel untuk melacak indeks dialog yang sedang ditampilkan
var current_dialogue_index: int = 0

var dialogue_fisnished: bool = false

@onready var dialogue_box_info: RichTextLabel = $Info/Dialogue/DialogueBox/MarginContainer/Text
@onready var dialogue_box_tutorial: RichTextLabel = $Tutorial/Dialogue/DialogueBox/MarginContainer/Text
@onready var fade: AnimationPlayer = $Animation/close

func _ready() -> void:
	# Tampilkan dialog pertama saat scene siap
	update_dialogue_info()
	update_dialogue_tutorial()
	dialogue_box_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	

func update_dialogue_info() -> void:
	if current_dialogue_index < dialogue.size():
		# Tampilkan dialog saat ini
		dialogue_box_info.text = dialogue[current_dialogue_index]
	else:
		# Jika semua dialog sudah ditampilkan, sembunyikan kotak dialog atau lakukan aksi lain
		fade.play("fade")
		dialogue_fisnished = true

func update_dialogue_tutorial() -> void:
	dialogue_box_tutorial.text = "Hover kartu untuk melihat dialog"

## Fungsi ini akan dipanggil ketika tombol diklik
func _on_button_pressed() -> void:
	# Cek apakah masih ada dialog yang belum ditampilkan
	if current_dialogue_index < dialogue.size():
		# Pindah ke dialog berikutnya
		current_dialogue_index += 1
		# Perbarui tampilan
		update_dialogue_info()
	
		if !dialogue_fisnished:
			$Info/Dialogue/DialogueBox.scale = Vector2(0,0)
			
			var tween: Tween = create_tween()
			tween.set_trans(Tween.TRANS_SPRING)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property($Info/Dialogue/DialogueBox, "scale", Vector2(1,1), 0.3)
	
	SoundEffect.pressed()

func _on_button_mouse_entered() -> void:
	SoundEffect.hover()


func _on_close_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		$Info.visible = false
		emit_signal("animation_info_finish")
		
		fade.play("fade_tutor")

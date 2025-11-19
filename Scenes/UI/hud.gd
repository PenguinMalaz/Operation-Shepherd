extends Node
class_name HUD

# Untuk menentukan jumlah heart
var heart: int = 3

# Total predator sesuai dengan jumlah predator di card board
var total_predator: int = 1
# Ketika predator ditemukan
var predator_ditemukan: int = 0
# Menyimpan score
var score: int = 0
# Menyimpan target score
var target_score: int = 0

# Node heart 1
@onready var heart_1: AnimatedSprite2D = $Heart/Panel/Heart1
# Node heart 2
@onready var heart_2: AnimatedSprite2D = $Heart/Panel/Heart2
# Node heart 3
@onready var heart_3: AnimatedSprite2D = $Heart/Panel/Heart3

# Node text dari predator found
@onready var predator_counter: RichTextLabel = $"Predator found/Panel/RichTextLabel"
# Node text dari score
@onready var score_label: RichTextLabel = $"Score/Panel/RichTextLabel"
# Node text dari task find predator
@onready var task_find_predator: RichTextLabel = $Task/FindPredator/RichTextLabel
# Node text dari task target score
@onready var task_target_score: RichTextLabel = $"Task/Target Score/RichTextLabel"

# Preload scene game over dan next level


func _ready() -> void:
	## Set UI
	# Jika heart berkurang maka UI heart akan ter-update
	heart_frame(0,0,0)
	
	if predator_counter:
		update_predator_display()
	
	if score_label:
		update_score_display()
	
	if task_find_predator and task_target_score:
		update_task_display()

## Mengatur UI dari heart
func heart_frame(heart_1_frame: int, heart_2_frame: int, heart_3_frame: int) -> void:
	heart_1.frame = heart_1_frame
	heart_2.frame = heart_2_frame
	heart_3.frame = heart_3_frame

## Fungsi untuk mengurangi heart
func kurangi_heart() -> void:
	if heart > 0:
		heart -= 1
	
	GlobalVariable.CURRENT_HEART = heart # update heart saat ini
	heart = clamp(heart, 0, 3)
	
	if heart == 2:
		heart_frame(0,0,1)
	elif heart == 1:
		heart_frame(0,1,1)
	elif heart == 0:
		heart_frame(1,1,1)
		$GameOver/AnimationPlayer.play("play")
		$GameOver.visible = true
		SoundEffect.gameover()

## Menambah score dan mengubah tampilan UI
func predator_ditemukan_bertambah() -> void:
	if predator_ditemukan < total_predator:
		predator_ditemukan += 1
		update_predator_display()
		
		tambah_score(100)
	
	if predator_ditemukan == total_predator:
		await get_tree().create_timer(0.5).timeout
		$NextLevel/AnimationPlayer.play("play")
		$NextLevel.visible = true

## Fungsi untuk menambahkan score
func tambah_score(poin: int) -> void:
	score += poin
	GlobalVariable.CURRENT_TOTAL_SCORE += score  # update global total score saat ini
	update_score_display()

## Mengatur total predator
func set_total_predator(total: int) -> void:
	total_predator = total
	
	# Hitung Target Score
	target_score = total_predator * 100
	
	update_predator_display() 
	update_task_display()

## Fungsi untuk memperbarui tampilan score
func update_score_display() -> void:
	var teks_hijau_angka: String = "[color=#a7d694]%d[/color]" % score
	var teks_final: String = "Score : %s" % teks_hijau_angka
	
	score_label.text = teks_final

## Fungsi untuk memperbarui tampilan task
func update_task_display() -> void:
	var teks_merah_total_predator: String = "[color=#b35054]%d[/color]" % total_predator
	task_find_predator.text = "Temukan %s predator" % teks_merah_total_predator
	
	var teks_hijau_target_score: String = "[color=#a7d694]%d[/color]" % target_score
	task_target_score.text = "Target %s score" % teks_hijau_target_score

## Fungsi untuk memperbarui tampilan predator found
func update_predator_display() -> void:
	var teks_merah_angka: String = "[color=#b35054]%d[/color]" % predator_ditemukan
	var teks_merah_total: String = "[color=#b35054]%d[/color]" % total_predator
	var teks_merah_slash: String = "[color=#b35054]/[/color]"
	
	# Gabungkan semua bagian
	var teks_final: String = "Predator ditemukan : %s%s%s" % [
		teks_merah_angka,
		teks_merah_slash,
		teks_merah_total
	]
	
	predator_counter.text = teks_final


func _on_play_button_down() -> void:
	$Fade.fade("res://Scenes/UI/MainMenu/MainMenu.tscn")
	SoundEffect.pressed()


func _on_play_mouse_entered() -> void:
	SoundEffect.hover()

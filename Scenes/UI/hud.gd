extends Node
class_name HUD

signal is_predator_found

# Untuk menentukan jumlah heart
var heart: int = 3

# Total predator sesuai dengan jumlah predator di card board
var total_predators: int = 1
# Ketika predator ditemukan
var predators_found: int = 0

# Node heart 1
@onready var heart_1: AnimatedSprite2D = $Heart/Heart1
# Node heart 2
@onready var heart_2: AnimatedSprite2D = $Heart/Heart2
# Node heart 3
@onready var heart_3: AnimatedSprite2D = $Heart/Heart3

# Node text dari predator found
@onready var predator_counter: RichTextLabel = $"Predator found/RichTextLabel2"

var paused: bool = false

func _ready() -> void:
	## Set UI
	# Jika heart berkurang maka UI heart akan ter-update
	heart_frame(0,0,0)
	
	if predator_counter:
		update_predator_display()
	
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		paused = !paused
		GlobalVariable.cursor = true
		if !paused:
			$Option.hide()
			get_tree().paused = true
			paused = false
		else:
			$Option.show()
			get_tree().paused = false
			paused = false
			
	
	if GlobalVariable.fade:
		await  get_tree().create_timer(0.5).timeout
		$Fade/AnimationPlayer.play("fade")

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
	if predators_found < total_predators:
		predators_found += 1
		update_predator_display()
		
	
	if predators_found == total_predators:
		emit_signal("is_predator_found")
		
		await get_tree().create_timer(0.5).timeout
		$NextLevel/AnimationPlayer.play("play")
		$NextLevel.visible = true

## Mengatur total predator
func set_total_predator(total: int) -> void:
	total_predators = total
	
	update_predator_display() 
	

## Fungsi untuk memperbarui tampilan predator found
func update_predator_display() -> void:
	var teks_merah_angka: String = "[color=#b35054]%d[/color]" % predators_found
	var teks_merah_slash: String = "[color=#b35054]/[/color]"
	var teks_merah_total: String = "[color=#b35054]%d[/color]" % total_predators
	
	# Gabungkan semua bagian
	var teks_final: String = " %s%s%s" % [
		teks_merah_angka,
		teks_merah_slash,
		teks_merah_total
	]
	
	predator_counter.text = teks_final

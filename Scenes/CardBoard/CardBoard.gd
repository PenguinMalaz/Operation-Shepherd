extends Node
class_name CardBoard

# Signal serigala
signal Serigala
# Signal domba
signal Domba

# Variabel yang akan menyimpan objek yang terpilih untuk sesi game ini
@export var object_penentu: ObjekDanDialog = preload("res://Resources/ObjekDanDialog/Pensil.tres")
# Deck yang akan digunakan
@export_enum("Deck 1", "Deck 2") var pilih_deck: String = "Deck 1"
# Variabel Export Baru: Mengatur jumlah Serigala (1 hingga 5)
@export var jumlah_serigala: int = 1
# Menentukan agar serigala tidak lebih dari total kartu
var total_kartu: int = 5

# Akses semua Node Kartu menggunakan onready
# Deck 1 berisi 5 kartu
@onready var deck_1: Array = [
	$CardDeck5/Card1, 
	$CardDeck5/Card2, 
	$CardDeck5/Card3, 
	$CardDeck5/Card4, 
	$CardDeck5/Card5
]

# Deck 2 berisi 6 kartu
@onready var deck_2: Array = [
	$CardDeck6/Card1, 
	$CardDeck6/Card2, 
	$CardDeck6/Card3, 
	$CardDeck6/Card4, 
	$CardDeck6/Card5,
	$CardDeck6/Card6
]

# Node card_object
@onready var card_object: Node2D = $CardObject
# Node card deck 1
@onready var card_deck_1: Node2D = $CardDeck5
# Node card deck 2
@onready var card_deck_2: Node2D = $CardDeck6
# Node magnifying glass
@onready var magnifying_glass: CanvasLayer = $"Maginifying Glass"
# Node cursor magnifying glass
@onready var cursor_magnifying_glass: Sprite2D = $"Cursor/Magnifying Glass"
# Node cursor normal
@onready var cursor_normal: Sprite2D = $Cursor/CursorNormal


# Menyimpan id dari setiap card
var deck_kartu: Array = []
# Deck saat ini
var current_deck: Array = []

# Id domba
const ID_DOMBA = Card.IdCard.DOMBA
# Id serigala
const ID_SERIGALA = Card.IdCard.SERIGALA
# Array yang menampung SEMUA nama objek (untuk diacak)
#const NAMA_OBJEK: Array = ["Pensil", "Penghapus", "Kertas", "Pengserut", "Pulpen"]

func _ready() -> void:
	randomize() 
	
	# Memastikan jumlah_serigala tidak melebihi batas (walaupun @export_range sudah membatasinya di editor)
	jumlah_serigala = clamp(jumlah_serigala, 1, total_kartu)
	
	if pilih_deck == "Deck 1":
		terapkan_deck(deck_1, 5, true, false)
	else:
		terapkan_deck(deck_2, 6, false, true)
	
	# Panggil fungsi untuk menetapkan peran (Domba/Serigala)
	tetapkan_peran_kartu(current_deck)
	
	# Menetapkan card id object
	card_object.current_object = object_penentu

func _process(_delta: float) -> void:
	if magnifying_glass.investigation_active:
		cursor_magnifying_glass.visible = true
		cursor_normal.visible = false
	else:
		cursor_magnifying_glass.visible = false
		cursor_normal.visible = true

## Untuk menerapkan deck mana yang dipilih
func terapkan_deck(deck: Array, jml_kartu: int, deck_1_visible: bool,deck_2_visible: bool) -> void:
	current_deck = deck
	card_deck_1.visible = deck_1_visible
	card_deck_2.visible = deck_2_visible
	total_kartu = jml_kartu
	for card: Card in deck:
		card.connect("card_clicked", _on_card_clicked)

## Untuk mengeliminasi kartu
func _on_card_clicked(card: Card) -> void:
	if magnifying_glass.investigation_active and card.card_flipped:
		periksa_kartu(card.id_card)
		card.button_disabled = true
		card.eliminated.play("eliminated")
		SoundEffect.glasss()
		

## Memeriksa id kartu
func periksa_kartu(kartu_id: Card.IdCard) -> void:
	match kartu_id:
		Card.IdCard.SERIGALA:
			emit_signal("Serigala")
			SoundEffect.wolfs()
		Card.IdCard.DOMBA:
			emit_signal("Domba")
			SoundEffect.sheeps()

## --- FUNGSI PENETAPAN PERAN DAN DIALOG ---
func tetapkan_peran_kartu(deck: Array) -> void:
	# 1. Hitung jumlah Domba
	var jumlah_domba: int = total_kartu - jumlah_serigala
	
	# 2. Buat Array untuk menyimpan posisi indeks yang akan menjadi Serigala
	var semua_indeks: Array = []
	for i in range(total_kartu):
		semua_indeks.append(i)
		
	semua_indeks.shuffle()
	var indeks_serigala_terpilih: Array = semua_indeks.slice(0, jumlah_serigala)
	
	# 4. Persiapkan Array Dialog Sementara (Unik)
	var dialog_domba_sisa: Array = object_penentu.domba_dialogs.duplicate()
	var dialog_serigala_sisa: Array = object_penentu.serigala_dialogs.duplicate()
	
	# 5. Cek Ketersediaan Dialog (Sama seperti sebelumnya)
	if dialog_domba_sisa.size() < jumlah_domba or dialog_serigala_sisa.size() < jumlah_serigala:
		push_error("ERROR: Data dialog tidak cukup! Butuh %d dialog Domba dan %d dialog Serigala." % [jumlah_domba, jumlah_serigala])
		return 
	
	# 6. Iterasi dan Panggil Fungsi Pembantu
	for i in range(deck.size()):
		var card: Card = deck[i]
		
		# Cek apakah indeks saat ini termasuk di antara indeks Serigala yang terpilih
		if i in indeks_serigala_terpilih:
			# Panggil fungsi terpisah untuk Serigala
			_tetapkan_dialog_kartu(card, ID_SERIGALA, dialog_serigala_sisa)
		else:
			# Panggil fungsi terpisah untuk Domba
			_tetapkan_dialog_kartu(card, ID_DOMBA, dialog_domba_sisa)

## Menetapkan dialog kartu
func _tetapkan_dialog_kartu(card: Card, role_id: Card.IdCard, dialog_array_sisa: Array) -> void:
	# 1. Tetapkan Peran pada Kartu
	card.id_card = role_id
	
	# 2. Ambil Dialog Acak UNIK (Pop dari array sisa)
	
	# Cek ketersediaan (Safety Check)
	if dialog_array_sisa.is_empty():
		card.dialog = "DIALOG HABIS!" 
		push_error("Tidak ada dialog unik tersisa untuk peran ", role_id)
		return
		
	var indeks_dialog: int = randi() % dialog_array_sisa.size()
	var dialog_template: String = dialog_array_sisa[indeks_dialog]
	
	# Hapus dialog dari array sisa agar tidak terpilih lagi! (Memastikan Keunikan)
	dialog_array_sisa.remove_at(indeks_dialog)
	
	# 3. Format dan Tetapkan ke Kartu
	card.dialog = dialog_template.format({"object": object_penentu})

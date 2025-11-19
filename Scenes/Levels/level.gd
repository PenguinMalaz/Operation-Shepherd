extends Node2D
class_name Level

@onready var cardboard: CardBoard = $CardBoard
@onready var hud: HUD = $Hud
@onready var level_complete: CanvasLayer = $Hud/NextLevel
@onready var game_over: CanvasLayer = $Hud/GameOver

@export var next_level_scene: String = ""
@export var current_level: int = 0

func _ready() -> void:
	
	Music.stop_main_menu()
	
	# Hubungkan sinyal Domba
	if cardboard:
		cardboard.connect("Domba", _on_cardboard_domba)
		
	# Hubungkan sinyal Serigala
	if cardboard:
		cardboard.connect("Serigala", _on_cardboard_serigala)
	
	# Mengatur total predator di HUD dari CardBoard
	if cardboard and hud:
		hud.set_total_predator(cardboard.jumlah_serigala)
	
	level_complete.go_to_next_level = next_level_scene
	
	
	if not Music.is_playing_gameplay():
		Music.play_gameplay()
	
	if Music.is_playing_investigation():
		Music.stop_investigation()
	

func _process(_delta: float) -> void:
	## Set rich text label (UI)
	level_complete.total_score = hud.score
	level_complete.current_heart = hud.heart
	level_complete.predator_found = hud.predator_ditemukan
	
	game_over.end_score = hud.score
	game_over.end_target_score = hud.target_score
	game_over.predators_left = (hud.total_predator - hud.predator_ditemukan)

## Mengurangi heart di HUD
func _on_cardboard_domba() -> void:
	# Logika untuk mengurangi heart
	if hud:
		hud.kurangi_heart()
		if hud.heart == 0:
			$"CardBoard/Maginifying Glass".investigation_active = false

## Ketika serigala ditemukan text predator found akan bertambah
func _on_cardboard_serigala() -> void:
	# Memanggil fungsi di HUD untuk menambah count
	hud.predator_ditemukan_bertambah()
	if hud.predator_ditemukan == hud.total_predator:
		$"CardBoard/Maginifying Glass".investigation_active = false
		GlobalVariable.unlock_next_level(current_level)

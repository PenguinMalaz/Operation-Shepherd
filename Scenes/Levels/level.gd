extends Node2D
class_name Level

@onready var cardboard: CardBoard = $CardBoard
@onready var hud: HUD = $Hud
@onready var level_complete: CanvasLayer = $Hud/NextLevel
@onready var game_over: CanvasLayer = $Hud/GameOver
@onready var magnifying_glass: CanvasLayer = $"CardBoard/Maginifying Glass"
@onready var magnifying_glass_button: AnimatedSprite2D = $"CardBoard/Maginifying Glass/Button/AnimatedSprite2D"

var dog_card: CanvasLayer = null
var tutorial: CanvasLayer = null
var tutorial_dog: CanvasLayer = null


@export var next_level_scene: String = ""
@export var current_level: int = 0

# Hanya untuk tutorial
var predator_clicked: bool = false

func _ready() -> void:
	Music.stop_main_menu()
	
	Leaves.hide()
	
	# Hubungkan sinyal Domba
	if cardboard:
		cardboard.connect("Domba", _on_cardboard_domba)
		
	# Hubungkan sinyal Serigala
	if cardboard:
		cardboard.connect("Serigala", _on_cardboard_serigala)
	
	if cardboard:
		cardboard.connect("Fox", _on_cardboard_fox)
	
	# Mengatur total predator di HUD dari CardBoard
	if cardboard and hud:
		hud.set_total_predator(cardboard.jumlah_serigala + cardboard.jumlah_fox)
	
	
	
	level_complete.go_to_next_level = next_level_scene
	
	
	if not Music.is_playing_gameplay():
		Music.play_gameplay()
	
	if Music.is_playing_investigation():
		Music.stop_investigation()
	
	# Hanya saat tutorial
	if current_level == 1:
		tutorial = $Tutorial
		if tutorial:
			tutorial.connect("animation_info_finish", _on_ordering_card)
			for card: Card in cardboard.current_deck:
				card.connect("card_hover_entered", _on_card_hover_entered)
				card.connect("card_hover_exited", _on_card_hover_exited)
				card.connect("card_clicked", _on_card_clicked)
			
			hud.connect("is_predator_found", _tutorial_fade)
	elif current_level == 4 or current_level == 5:
		dog_card = $DogCard
		if current_level == 4:
			tutorial_dog = $Tutorial
			if tutorial_dog:
				tutorial_dog.connect("animation_info_finish", _on_ordering_card_dog)
				for card: Card in cardboard.current_deck:
					card.connect("card_clicked", _on_card_clicked)
	
	if dog_card:
		dog_card.dog_mode.connect(_on_dog_mode)
	
	cardboard.connect("pinned", _hide_dog)
	
	magnifying_glass.connect("button_pressed", _elimination)
	

func _process(_delta: float) -> void:
	## Set rich text label (UI)
	level_complete.current_heart = hud.heart
	level_complete.predator_found = hud.predators_found
	
	game_over.predators_found = hud.predators_found
	game_over.predators_left = (hud.total_predators - hud.predators_found)
	game_over.total_predators = hud.total_predators
	
	if hud.predators_found == hud.total_predators:
		cardboard.is_level_complete = true
	elif hud.heart == 0:
		cardboard.is_level_complete = true
	

## Mengurangi heart di HUD
func _on_cardboard_domba() -> void:
	# Logika untuk mengurangi heart
	if hud:
		hud.kurangi_heart()
		if hud.heart == 0:
			magnifying_glass.investigation_active = false

## Ketika serigala ditemukan text predator found akan bertambah
func _on_cardboard_serigala() -> void:
	# Memanggil fungsi di HUD untuk menambah count
	hud.predator_ditemukan_bertambah()
	if hud.predators_found == hud.total_predators:
		magnifying_glass.investigation_active = false
		GlobalVariable.unlock_next_level(current_level)

## Ketika fox ditemukan text predator found akan bertambah
func _on_cardboard_fox() -> void:
	hud.predator_ditemukan_bertambah()
	if hud.predators_found == hud.total_predators:
		magnifying_glass.investigation_active = false
		GlobalVariable.unlock_next_level(current_level)

## ========== Hanya untuk tutorial ==========
## Mengubah layer/z index
func _on_ordering_card() -> void:
	for card: Card in cardboard.current_deck:
		card.z_index = 50
	tutorial.layer = -1
	
	var tween: Tween = create_tween()
	cardboard.magnifying_glass.layer = -1
	tween.tween_property(magnifying_glass_button, "modulate", Color("818181ff"), 0.5)

## Penanganan saat kursor masuk ke kartu
func _on_card_hover_entered(card_node: Card) -> void:
	if tutorial or tutorial_dog:
		if !predator_clicked:
			tween_hover()
			dialog_card(card_node)

## Penanganan saat kursor keluar dari kartu
func _on_card_hover_exited() -> void:
	if tutorial or tutorial_dog:
		if !predator_clicked:
			tween_hover()
			tutorial.dialogue_box_tutorial.text = "$dialog_tutorial_6"

func tween_hover() -> void:
	var dialogue_box: MarginContainer = $Tutorial/Tutorial/Dialogue/DialogueBox
	dialogue_box.scale = Vector2(0,0)
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(dialogue_box, "scale", Vector2(0.5,0.5), 0.3)

func dialog_card(card_node: Card) -> void:
	if tutorial:
		if !predator_clicked:
			if card_node.suspect:
				tutorial.dialogue_box_tutorial.text = "$dialog_tutorial_7"
			else:
				tutorial.dialogue_box_tutorial.text = "$dialog_tutorial_8"

func _on_card_clicked(card_node: Card) -> void:
	if tutorial or tutorial_dog:
		dialog_card(card_node)
		tween_hover()
		if tutorial:
			if card_node.suspect:
				match card_node.id_card:
					Card.IdCard.SERIGALA:
						tutorial.dialogue_box_tutorial.text = "$dialog_tutorial_9"
						predator_clicked = true
						var tween: Tween = create_tween()
						cardboard.magnifying_glass.layer = 1
						tween.tween_property(magnifying_glass_button, "modulate", Color("ffffffff"), 0.5)
				
			else:
				match card_node.id_card:
					Card.IdCard.SERIGALA:
						predator_clicked = false
				if !predator_clicked:
					tutorial.dialogue_box_tutorial.text = "$dialog_tutorial_10"
		
		if tutorial_dog:
			if card_node.pinned:
				var tweens: Tween = create_tween()
				tweens.tween_property(tutorial_dog.tutorial, "modulate", Color("81818100"), 0.5)
				for card: Card in cardboard.current_deck:
					card.z_index = 50
				await  tweens.finished
				tutorial_dog.queue_free()

func _tutorial_fade() -> void:
	tutorial.fade.play_backwards("fade_tutor")

func _elimination() -> void:
	if predator_clicked:
		if magnifying_glass.elimination:
			tutorial.dialogue_box_tutorial.text = "$dialog_tutorial_10"
			tween_hover()
			
		else:
			tutorial.dialogue_box_tutorial.text = "$dialog_tutorial_9"
			tween_hover()
			
	if dog_card:
		if magnifying_glass.elimination:
			$"DogCard/Dog Card/Dialogue/Button".disabled = true
			$"DogCard/Dog Card".modulate = Color("818181ff")
		else:
			$"DogCard/Dog Card/Dialogue/Button".disabled = false
			$"DogCard/Dog Card".modulate = Color("ffffffff")

func _on_dog_mode(mode: bool) -> void:
	SoundEffect.flip()
	if mode:
		for card: Card in cardboard.current_deck:
			if !card.pinned:
				card.flip_dog(true)
				card.dog_mode = true
				
			var tween: Tween = create_tween()
			tween.tween_property(magnifying_glass_button, "modulate", Color("818181ff"), 0.5)
			$"CardBoard/Maginifying Glass/Button".disabled = true
			magnifying_glass.dog_mode = true
			if tutorial_dog:
				tutorial_dog.dialogue_box_tutorial.text = "$fox_dialog_tutorial_8"
	else:
		var tween: Tween = create_tween()
		tween.tween_property(magnifying_glass_button, "modulate", Color("ffffffff"), 0.5)
		$"CardBoard/Maginifying Glass/Button".disabled = false
		magnifying_glass.dog_mode = false
		for card: Card in cardboard.current_deck:
			if !card.pinned:
				card.flip_dog(false)
				card.dog_mode = false
				card.suspect_with_magnifying_glass = false
				card.button.disabled = false
				if tutorial_dog:
					tutorial_dog.dialogue_box_tutorial.text = "$fox_dialog_tutorial_6"
					


func _hide_dog() -> void:
	magnifying_glass.dog_mode = false
	var tween: Tween = create_tween()
	tween.tween_property(magnifying_glass_button, "modulate", Color("ffffffff"), 0.3)
	tween.tween_property($"DogCard/Dog Card", "modulate", Color("ffffff00"), 0.3)
	tween.tween_property($"DogCard/Dog Card/Dialogue/Button", "disabled", true, 0.0)
	
	$"CardBoard/Maginifying Glass/Button".disabled = false
	for card: Card in cardboard.current_deck:
			if !card.pinned:
				card.flip_dog(false)
				card.dog_mode = false
	await  get_tree().create_timer(0.5).timeout
	dog_card.queue_free()


func _on_ordering_card_dog() -> void:
	for card: Card in cardboard.current_deck:
		card.z_index = 50
	tutorial_dog.layer = -1
	
	var tween: Tween = create_tween()
	cardboard.magnifying_glass.layer = -1
	tween.tween_property(magnifying_glass_button, "modulate", Color("818181ff"), 0.5)

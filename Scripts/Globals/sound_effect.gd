extends Node

@onready var button_hover: AudioStreamPlayer = $ButtonHover
@onready var button_pressed: AudioStreamPlayer = $ButtonPressed
@onready var game_over: AudioStreamPlayer = $GameOver
@onready var glass: AudioStreamPlayer = $Glass
@onready var score: AudioStreamPlayer = $Score
@onready var sheep: AudioStreamPlayer = $Sheep
@onready var wolf: AudioStreamPlayer = $Wolf
@onready var pop: AudioStreamPlayer = $Pop
@onready var card_flip: AudioStreamPlayer = $flip
@onready var gunshoot: AudioStreamPlayer = $Gunshoot
@onready var glass_double: AudioStreamPlayer = $GlassDouble
@onready var reload: AudioStreamPlayer = $Reload
@onready var fox: AudioStreamPlayer = $Fox
@onready var dog: AudioStreamPlayer = $Dog
@onready var pin: AudioStreamPlayer = $Pin

func hover() -> void:
	button_hover.play()

func pressed() -> void:
	button_pressed.play()

func gameover() -> void:
	game_over.play()

func glasss() -> void:
	glass.play()

func scores() -> void:
	score.play()

func sheeps() -> void:
	sheep.play()

func wolfs() -> void:
	wolf.play()

func pops() -> void:
	pop.play()

func flip() -> void:
	card_flip.play()

func shoot() -> void:
	gunshoot.play()

func glass_double_deselect() -> void:
	glass_double.play()

func reload_() -> void:
	reload.play()

func fox_hurt() -> void:
	fox.play()

func bark() -> void:
	dog.play(0.24)

func pin_() -> void:
	pin.play()

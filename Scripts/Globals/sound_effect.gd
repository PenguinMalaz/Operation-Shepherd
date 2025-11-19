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

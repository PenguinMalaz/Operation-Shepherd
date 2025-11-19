extends Node
class_name Card
## Card
## Scene ini untuk di inheritance di scene lain

enum IdCard{
	DOMBA,
	SERIGALA,
}

# Signal untuk mengecek kartu di klik
signal card_clicked(card: Card)

# Id card
@export var id_card: IdCard
# Dialog card
@export var dialog: String = ""

# Disabled button
@export var button_disabled: bool = false
# Card flipped
var card_flipped: bool = false

# Node dari sprite
@onready var sprite: Sprite2D = $Button/Sprite
# Node sound card hover
@onready var card_hover: AudioStreamPlayer = $Audio/CardHover
# Node animation card fliped
@onready var flip: AnimationPlayer = $Animations/Flip
# Node text dialogue
@onready var dialogue_text: RichTextLabel = $DialogueBox/MarginContainer/Text
# Node animation dialogue box faded
@onready var dialogue_box_fade: AnimationPlayer = $Animations/DialogueBoxFade
# Node animation loop
@onready var loop: AnimationPlayer = $Animations/Loop
# Node animation elimated
@onready var eliminated: AnimationPlayer = $Animations/Eliminated
# Node button
@onready var button: Button = $Button

# Texture domba
const texture_domba = preload("res://Asset/Sprite/Cards/Domba.png")
# Texture serigala
const texture_serigala = preload("res://Asset/Sprite/Cards/Serigala.png")

func _process(_delta: float) -> void:
	# Mengatur text dialog
	dialogue_text.text = dialog
	
	# Menonaktifkan kartu
	if button_disabled:
		button.disabled = true
		sprite.self_modulate = Color(0.374, 0.374, 0.374, 1.0)
		loop.pause()
		terapkan_texture()
	else:
		button.disabled = false
	
	

## Menerapkan texture ketika kartu di eliminasi
func terapkan_texture() -> void:
	if id_card == IdCard.DOMBA :
		sprite.texture = texture_domba
	elif id_card == IdCard.SERIGALA :
		sprite.texture = texture_serigala

## Hover entered card
func _on_button_mouse_entered() -> void:
	if !button_disabled:
		sprite.scale = Vector2(1.1, 1.1)
		card_hover.play()
		if card_flipped:
			dialogue_box_fade.play("fade")

## Hover exited card
func _on_button_mouse_exited() -> void:
	if !button_disabled:
		sprite.scale = Vector2(1, 1)
		if card_flipped:
			dialogue_box_fade.play_backwards("fade")

## Button down
func _on_button_button_down() -> void:
	if !card_flipped:
		flip.play("Flip")
		dialogue_box_fade.play("fade")
		loop.play("loop")
	emit_signal("card_clicked", self)

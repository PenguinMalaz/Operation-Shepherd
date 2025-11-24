extends Node
class_name Card
## Card
## Scene ini untuk di inheritance di scene lain

# Signal untuk memberi tahu CardBoard bahwa kursor masuk
signal card_hover_entered
# Signal untuk memberi tahu CardBoard bahwa kursor keluar
signal card_hover_exited

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
@export var card_flipped: bool = false

# Node dari sprite
@onready var sprite: Sprite2D = $Button/Sprite
# Node animation card fliped
@onready var flip: AnimationPlayer = $Animations/Flip
# Node text dialogue
@onready var dialogue_text: RichTextLabel = $DialogueBox/MarginContainer/Text
# Node animation dialogue box faded
@onready var dialogue_box_fade: AnimationPlayer = $Animations/DialogueBoxFade
# Node animation loop
@onready var loop: AnimationPlayer = $Animations/Loop
# Node animation elimated
@onready var suspect_anim: AnimationPlayer = $Animations/Suspect
# Node button
@onready var button: Button = $Button
# Node magnifying glass
@onready var magnifying_glass_sprite: Sprite2D = $Button/Sprite/Sprite2D
# Node elimination mode
@onready var elimination_mode: AnimationPlayer = $Animations/EliminationMode

# Texture domba
const texture_domba = preload("res://Asset/Sprite/Cards/door-card-sheep.png")
# Texture serigala
const texture_serigala = preload("res://Asset/Sprite/Cards/door-card-wolf.png")

var suspect: bool = false

var is_mouse_can_entered: bool = false

func _process(_delta: float) -> void:
	# Mengatur text dialog
	dialogue_text.text = dialog
	
	# Menonaktifkan kartu
	if button_disabled:
		button.disabled = true
		loop.pause()
		terapkan_texture()
		sprite.self_modulate = Color(0.577, 0.577, 0.577, 1.0)
	
	
## Menerapkan texture ketika kartu di eliminasi
func terapkan_texture() -> void:
	if id_card == IdCard.DOMBA :
		sprite.texture = texture_domba
	elif id_card == IdCard.SERIGALA :
		sprite.texture = texture_serigala



## Hover entered card
func _on_button_mouse_entered() -> void:
	if !is_mouse_can_entered:
		if !button_disabled:
			if !suspect:
				flip.play("Flip")
				loop.play("loop")
				SoundEffect.flip()
			
			dialogue_box_fade.play("fade")
			emit_signal("card_hover_entered", self)

## Hover exited card
func _on_button_mouse_exited() -> void:
	if !is_mouse_can_entered:
		if !button_disabled:
			if !suspect:
				flip.play_backwards("Flip")
				loop.play("RESET")
				SoundEffect.flip()
				
			dialogue_box_fade.play_backwards("fade")
			emit_signal("card_hover_exited")

## Button down
func _on_button_button_down() -> void:
	emit_signal("card_clicked", self)

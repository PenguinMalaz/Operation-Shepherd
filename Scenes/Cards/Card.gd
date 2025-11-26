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
	FOX
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
# Node pin
@onready var pin: Sprite2D = $Button/Sprite/Pin
# Node pin animation
@onready var pin_anim: AnimationPlayer = $Animations/Pin


# Texture domba
const texture_domba = preload("res://Asset/Sprite/Cards/door-card-sheep.png")
# Texture serigala
const texture_serigala = preload("res://Asset/Sprite/Cards/door-card-wolf.png")
# texture fox
const texture_fox = preload("res://Asset/Sprite/Cards/door-card-fox1.png")


const texture_pin_red = preload("res://Asset/Sprite/Level Selection/pin.png")
const texture_pin_green = preload("res://Asset/Sprite/Level Selection/pin-dog2.png")

var suspect: bool = false

var is_mouse_can_entered: bool = false

var dog_mode: bool = false

var pinned: bool = false

var suspect_with_magnifying_glass: bool = false

func _process(_delta: float) -> void:
	# Mengatur text dialog
	dialogue_text.text = dialog
	
	# Menonaktifkan kartu
	
	if pinned:
		loop.pause()
		if id_card == IdCard.DOMBA :
			button_disabled = true
			button.disabled = true
			sprite.self_modulate = Color(0.577, 0.577, 0.577, 1.0)
		else:
			suspect = true
			dog_mode = false
	else:
		_button_disabled()

func _button_disabled() -> void:
	if button_disabled:
		button.disabled = true
		loop.pause()
		terapkan_texture()
		sprite.self_modulate = Color(0.577, 0.577, 0.577, 1.0)
		elimination_mode.stop()

## Menerapkan texture ketika kartu di eliminasi
func terapkan_texture() -> void:
	if id_card == IdCard.DOMBA :
		sprite.texture = texture_domba
	elif id_card == IdCard.SERIGALA :
		sprite.texture = texture_serigala
	elif id_card == IdCard.FOX :
		sprite.texture = texture_fox


## Hover entered card
func _on_button_mouse_entered() -> void:
	if !is_mouse_can_entered:
		emit_signal("card_hover_entered", self)
		if !button_disabled:
			if !suspect:
				if !dog_mode:
					flip.play("Flip")
					loop.play("loop")
					SoundEffect.flip()
			
			dialogue_box_fade.play("fade")
			

## Hover exited card
func _on_button_mouse_exited() -> void:
	if !is_mouse_can_entered:
		emit_signal("card_hover_exited")
		if !button_disabled:
			if !suspect:
				if !dog_mode:
					flip.play_backwards("Flip")
					loop.play("RESET")
					SoundEffect.flip()
					
			dialogue_box_fade.play_backwards("fade")
			

## Button down
func _on_button_button_down() -> void:
	emit_signal("card_clicked", self)

func flip_dog(fliped: bool) -> void:
	if !button_disabled:
		if !suspect:
			if fliped:
				flip.play("Flip")
				loop.play("loop")
			else:
				flip.play_backwards("Flip")
				loop.play("RESET")

func apply_texture_pin() -> void:
	if !pinned:
		pin_anim.play("Pin")
		if id_card == IdCard.DOMBA :
			pin.texture = texture_pin_green
		elif id_card == IdCard.SERIGALA :
			pin.texture = texture_pin_red
		elif id_card == IdCard.FOX :
			pin.texture = texture_pin_red

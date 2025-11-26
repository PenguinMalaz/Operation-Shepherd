extends CanvasLayer

# Export variable score untuk ditampilkan di game over
var predators_found: int = 0
var predators_left: int = 0
var total_predators: int = 0

# Node text dari score
@onready var amount_of_predators_founded: RichTextLabel = $"GameOver/Predator left/HBoxContainer/Amount"
@onready var amount_of_remaining_predators: RichTextLabel = $"GameOver/Predator left/HBoxContainer2/Amount"
@onready var amount_of_predators: RichTextLabel = $"GameOver/Predator left/HBoxContainer3/Amount"

func _process(_delta: float) -> void:
	display_text()

func display_text() -> void:
	var color_red: String = "#bd726f"
	
	var new_predators_founded: String = "[color=" + color_red + "]" + str(predators_found) + "[/color]"
	var new_remaining_predators: String = "[color=" + color_red + "]" + str(predators_left) + "[/color]"
	var new_number_of_predators: String = "[color=" + color_red + "]" + str(total_predators) + "[/color]"
	
	amount_of_predators_founded.text = new_predators_founded
	amount_of_remaining_predators.text = new_remaining_predators
	amount_of_predators.text = new_number_of_predators

## Ketika tombol level selection ditekan
func _on_level_selection_btn_pressed() -> void:
	$Fade.fade("res://Scenes/UI/MainMenu/MainMenu.tscn")
	SoundEffect.pressed()
	timer_hold()

## Ketika tombol restart ditekan
func _on_restart_btn_pressed() -> void:
	$Fade.fade_reload_current_scene()
	SoundEffect.pressed()
	timer_hold()

## Level selection button hover
func _on_level_selection_btn_mouse_entered() -> void:
	SoundEffect.hover()

## Restart button hover
func _on_restart_btn_mouse_entered() -> void:
	SoundEffect.hover()

## Stop music
func timer_hold() -> void:
	Music.stop_gameplay()
	Music.stop_investigation()

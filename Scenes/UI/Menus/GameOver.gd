extends CanvasLayer

# Export variable score untuk ditampilkan di game over
var predators_found: int = 0
var predators_left: int = 0
var total_predators: int = 0

# Node text dari score
@onready var game_over_score_label: RichTextLabel = $"GameOver/Predator left"/Panel/RichTextLabel


func _process(_delta: float) -> void:
	display_text()

func display_text() -> void:
	var color_red: String = "#b35054"
	
	var format_string: String = "Predators found\t : [color=" + color_red + "]%d[/color]\n"
	format_string += "Predators left: [color=" + color_red + "]%d[/color]\n"
	format_string += "Total predators: [color=" + color_red + "]%d[/color]"
	
	game_over_score_label.text = format_string % [
		predators_found,
		predators_left, 
		total_predators,
	]

## Ketika tombol level selection ditekan
func _on_level_selection_btn_pressed() -> void:
	$Fade.fade("res://Scenes/UI/MainMenu/MainMenu.tscn")
	SoundEffect.pressed()
	timer_hold()

## Ketika tombol restart ditekan
func _on_restart_btn_pressed() -> void:
	get_tree().reload_current_scene()
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

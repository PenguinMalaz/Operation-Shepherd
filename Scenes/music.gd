extends Node

func play_main_menu() -> void:
	$MainMenu.play()

func play_gameplay() -> void:
	$Gameplay.play()
	
func play_investigation() -> void:
	$Investigation.play()

func stop_main_menu() -> void:
	$MainMenu.stop()

func stop_gameplay() -> void:
	$Gameplay.stop()
	
func stop_investigation() -> void:
	$Investigation.stop()

func is_playing_gameplay() -> bool:
	return $Gameplay.is_playing()

func is_playing_mainmenu() -> bool:
	return $MainMenu.is_playing()

func is_playing_investigation() -> bool:
	return $Investigation.is_playing()

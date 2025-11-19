extends Node

# Deklarasi variable untuk stat
var CURRENT_SCORE: int = 0
var CURRENT_TARGET_SCORE: int = 0
var CURRENT_TOTAL_SCORE: int = 0
var CURRENT_LEVEL: int = 1
var CURRENT_HEART: int = 3
var CURRENT_STATE: String = "standby"

var unlocked_level: int = 1

# Variable untuk menyimpan level.
var LEVEL_SCENES: Array[PackedScene] = [ 
	load("res://Scenes/Levels/Level_1.tscn"), 
	load("res://Scenes/Levels/Level_2.tscn"),
	load("res://Scenes/Levels/Level_3.tscn"),
	load("res://Scenes/Levels/Level_4.tscn"),
	load("res://Scenes/Levels/Level_5.tscn"),
]

# File path untuk menyimpan data
const SAVE_PATH: String = "user://level_data.dat"

func unlock_next_level(current_level: int) -> void:
	var next_level: int = current_level + 1
	
	# Hanya update jika level berikutnya lebih tinggi dari level tertinggi yang sudah terbuka
	if next_level > unlocked_level:
		unlocked_level = next_level
		
		# Panggil fungsi save di sini, karena data unlocked_level telah diubah
		save_game() 
		print("Level ", next_level, " unlocked and saved.")
	else:
		print("Level berikutnya sudah terbuka.")

func save_game() -> Error:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		print("ERROR: Could not open save file for writing: ", FileAccess.get_open_error())
		return ERR_CANT_CREATE
		
	# Buat dictionary berisi data yang ingin disimpan
	var save_data: Dictionary = {
		"unlocked_level": unlocked_level,
	}
	
	# Simpan data dalam format JSON
	var json_string: String = JSON.stringify(save_data)
	file.store_line(json_string)
	
	print("Game Saved! Unlocked Level: ", unlocked_level)
	return OK

# --- FUNGSI LOAD ---
func load_game() -> Error:
	if not FileAccess.file_exists(SAVE_PATH):
		print("Save file not found. Starting fresh.")
		# Jika file tidak ada, biarkan unlocked_level = 1 (default)
		return ERR_FILE_NOT_FOUND

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		print("ERROR: Could not open save file for reading: ", FileAccess.get_open_error())
		return ERR_CANT_OPEN

	# Baca JSON string
	var json_string: String = file.get_line()
	var parsed_data: Variant = JSON.parse_string(json_string)
	
	if not parsed_data is Dictionary:
		print("ERROR: Save data is corrupted or invalid.")
		return ERR_PARSE_ERROR
		
	var save_data: Dictionary = parsed_data
	
	# Terapkan data yang dimuat
	if save_data.has("unlocked_level"):
		unlocked_level = save_data["unlocked_level"]
	
	print("Game Loaded! Unlocked Level: ", unlocked_level)
	return OK

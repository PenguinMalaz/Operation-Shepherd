extends Node2D

## Objek yang ditanyakan saat ini
var current_object: ObjekDanDialog

# Node sprite card object
@onready var sprite: Sprite2D = $Sprite

# Texture kertas
var texture_kertas: Texture2D = preload("res://Asset/Sprite/Cards/Object/kertas 1.png")
# Texture pulpen
var texture_pulpen: Texture2D = preload("res://Asset/Sprite/Cards/Object/card-pen.png")
# Texture pensil
var texture_pensil: Texture2D = preload("res://Asset/Sprite/Cards/Object/card-pencil.png")
# Texture pengserut
var texture_pengserut: Texture2D = preload("res://Asset/Sprite/Cards/Object/card-pengserut.png")
# Texture penghapus
var texture_penghapus: Texture2D = preload("res://Asset/Sprite/Cards/Object/card-penghapus.png")


func _process(_delta: float) -> void:
	sprite.texture = current_object.card_texture

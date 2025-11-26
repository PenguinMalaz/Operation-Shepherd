extends CanvasLayer

var SceneString: String = ""
var play: bool = false
var reload_current_scene: bool = false

var add_or_delete: bool = false
var instance_scene: bool = false
var queue_free_scene: bool = false

var normal_fade: bool = false
var visible_canvas: bool = false


@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	SceneString = ""
	

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if normal_fade == true:
		normal_fade = false
		$AnimationPlayer.play("fade")
		visible_canvas = true
	
	if play == true:
		var _c: Error
		_c = get_tree().change_scene_to_file(SceneString)
		play = false
	
	if reload_current_scene:
		get_tree().reload_current_scene()
		reload_current_scene = false
	
	
	if add_or_delete:
		var packed_scene := load(SceneString) as PackedScene
		var inst := packed_scene.instantiate()
		if instance_scene:
			if packed_scene:
				get_tree().current_scene.add_child(inst)
				inst.on_level = true
				$AnimationPlayer.play("fade")
			instance_scene = false
		
		if queue_free_scene:
			var node := get_tree().current_scene.get_node_or_null("OptionsMenu")
			if node:
				node.queue_free()
				GlobalVariable.fade = false
			
			
			queue_free_scene = false
		add_or_delete = false
	


func fade(Scene : StringName) -> void:
	$AnimationPlayer.play_backwards("fade")
	SceneString = Scene
	play = true

func fade_normal() -> void:
	$AnimationPlayer.play_backwards("fade")
	normal_fade = true

func fade_reload_current_scene() -> void:
	$AnimationPlayer.play_backwards("fade")
	reload_current_scene = true

func fade_add_or_delete_scene(scene: String, condition: String) -> void:
	$AnimationPlayer.play_backwards("fade")
	SceneString = scene
	add_or_delete = true
	if condition == "instance":
		instance_scene = true
	elif condition == "queue_free":
		queue_free_scene = true
		GlobalVariable.fade = true

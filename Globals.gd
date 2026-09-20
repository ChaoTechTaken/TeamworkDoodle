extends Node

var current_scene : Node
var level_to_complete : int
var has_bitches : bool
var attempted_money : int
var levels : Array[StringName] = ["res://Level 1.tscn","res://Level 2.tscn"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_scene = get_tree().root.get_child(-1)
	level_to_complete = 0
	has_bitches = true
	attempted_money = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene(scene_path : String) -> void:
	_change_scene_deferred.call_deferred(scene_path)
	
func _change_scene_deferred(scene_path : String) -> void:
	current_scene.free()
	# Load the new scene.
	var s = ResourceLoader.load(scene_path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene

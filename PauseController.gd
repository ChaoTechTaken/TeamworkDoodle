extends Control

enum states {PAUSED, UNPAUSED}
var state : states = states.UNPAUSED
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_unpause()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if state == states.UNPAUSED:
			get_tree().paused = true
			_pause()
		elif state == states.PAUSED:
			get_tree().paused = false
			_unpause()

func _on_resume_pressed() -> void:
	if state == states.PAUSED:
		get_tree().paused = false
		_unpause()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	_unpause()
	Globals.change_scene("res://Main Menu.tscn")

func _pause() -> void:
	state = states.PAUSED
	$VBoxContainer.process_mode = Node.PROCESS_MODE_INHERIT
	$VBoxContainer.visible = true
	$Label.visible = true
	$ColorRect.visible = true

func _unpause() -> void:
	state = states.UNPAUSED
	$VBoxContainer.process_mode = Node.PROCESS_MODE_DISABLED
	$VBoxContainer.visible = false
	$Label.visible = false
	$ColorRect.visible = false

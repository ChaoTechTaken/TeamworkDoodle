extends Control

enum states {SPLASH, MAIN, LEVEL_SELECT, OPTIONS}
var _main_menu_processes : Dictionary[states, Callable]
var _main_menu_transitions : Dictionary[Array, Callable]
var state : states
var transition_to : states
var release_ignored_actions : Array[StringName]
var has_bitches : bool
var attempted_money : float
var current_level : int
var levels : Array[StringName] = ["res://Level 1.tscn"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = states.SPLASH
	Globals.has_bitches = $"Option Contents/Bitches".button_pressed
	Globals.attempted_money = $"Option Contents/MoneySlider".value
	$"Main Menu Buttons".process_mode = Node.PROCESS_MODE_DISABLED
	$"Main Menu Buttons".visible = false
	$"Level Select Buttons".process_mode = Node.PROCESS_MODE_DISABLED
	$"Level Select Buttons".visible = false
	$"Option Contents".process_mode = Node.PROCESS_MODE_DISABLED
	$"Option Contents".visible = false
	$Title.set_position(Vector2(306.5, 100))
	
	_main_menu_processes = {
		states.SPLASH : splash_process,
		states.MAIN : main_process,
		states.LEVEL_SELECT : level_select_process,
		states.OPTIONS : options_process
		}
	
	_main_menu_transitions = {
		[states.SPLASH, states.MAIN] : splash_to_main_transition,
		[states.MAIN, states.SPLASH] : main_to_splash_transition,
		[states.MAIN, states.LEVEL_SELECT] : main_to_level_select_transition,
		[states.LEVEL_SELECT,states.MAIN] : level_select_to_main_transition,
		[states.MAIN, states.OPTIONS] : main_to_options_transition,
		[states.OPTIONS,states.MAIN] : options_to_main_transition
	}
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if transition_to != state:
		if [state, transition_to] in _main_menu_transitions:
			if _main_menu_transitions[[state, transition_to]].call(delta):
				state = transition_to
			return
		else:
			state = transition_to
	
	_main_menu_processes[state].call(delta)

func splash_process(delta: float) -> void:
	pass
	
func main_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		transition_to = states.SPLASH
		release_ignored_actions.append("ui_cancel")

func level_select_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		transition_to = states.MAIN
		release_ignored_actions.append("ui_cancel")
	
func options_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		transition_to = states.MAIN
		release_ignored_actions.append("ui_cancel")
	
func splash_to_main_transition(delta: float) -> bool:
	$"Main Menu Buttons".process_mode = Node.PROCESS_MODE_INHERIT
	$"Main Menu Buttons".visible = true
	$Title.set_position(Vector2(306.5, -20.0))
	return true

func main_to_splash_transition(delta:float) -> bool:
	$"Main Menu Buttons".process_mode = Node.PROCESS_MODE_DISABLED
	$"Main Menu Buttons".visible = false
	$Title.set_position(Vector2(306.5, 100))
	return true
	
func main_to_level_select_transition(delta:float)->bool:
	$"Main Menu Buttons".process_mode = Node.PROCESS_MODE_DISABLED
	$"Main Menu Buttons".visible = false
	$"Level Select Buttons".process_mode = Node.PROCESS_MODE_INHERIT
	$"Level Select Buttons".visible = true
	return true

func level_select_to_main_transition(delta:float)->bool:
	$"Main Menu Buttons".process_mode = Node.PROCESS_MODE_INHERIT
	$"Main Menu Buttons".visible = true
	$"Level Select Buttons".process_mode = Node.PROCESS_MODE_DISABLED
	$"Level Select Buttons".visible = false
	return true

func main_to_options_transition(delta:float)->bool:
	$"Main Menu Buttons".process_mode = Node.PROCESS_MODE_DISABLED
	$"Main Menu Buttons".visible = false
	$"Option Contents".process_mode = Node.PROCESS_MODE_INHERIT
	$"Option Contents".visible = true
	return true
	
func options_to_main_transition(delta:float)->bool:
	$"Main Menu Buttons".process_mode = Node.PROCESS_MODE_INHERIT
	$"Main Menu Buttons".visible = true
	$"Option Contents".process_mode = Node.PROCESS_MODE_DISABLED
	$"Option Contents".visible = false
	return true

func _unhandled_input(event: InputEvent) -> void:
	var ignored = false
	for i in range(len(release_ignored_actions)-1, -1, -1):
		if event.is_action_released(release_ignored_actions[i]):
			release_ignored_actions.remove_at(i)
			ignored = true
	if ignored:
		return
	if event.is_released() and state == states.SPLASH:
		transition_to = states.MAIN

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.is_pressed() == false) and state == states.SPLASH:
		transition_to = states.MAIN

func _on_exit_pressed() -> void:
	get_tree().quit()
	
func _on_level_select_pressed() -> void:
	transition_to = states.LEVEL_SELECT

func _on_options_pressed() -> void:
	transition_to = states.OPTIONS

func update_money()->void:
	if Globals.has_bitches:
		$"Option Contents/MoneyText".text = str("Money : ",0,"$")
		return
	$"Option Contents/MoneyText".text = str("Money : ",int(Globals.attempted_money),"$")

func _on_money_slider_value_changed(value: float) -> void:
	Globals.attempted_money = value
	update_money()

func _on_bitches_toggled(toggled_on: bool) -> void:
	Globals.has_bitches = toggled_on
	update_money()

func _on_level_1_pressed() -> void:
	Globals.change_scene(Globals.levels[0])

func _on_start_pressed() -> void:
	Globals.change_scene(Globals.levels[Globals.level_to_complete])

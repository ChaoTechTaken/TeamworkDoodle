extends Node2D

@export var movement_speed : float = 100
@export var SnapTarget : Node2D
@export var CollisionArea : Area2D
@export var CurrentLevelNumber : int
var command_dir : Vector2
var movement_dir : Vector2
var finish_time : float

enum states {ACTIVE, FINISHED}
var state : states
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = states.ACTIVE
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	command_dir = Vector2(0,0)
	if Input.is_action_pressed("down"):
		command_dir += Vector2(0,1)
	if Input.is_action_pressed("up"):
		command_dir -= Vector2(0,1)
	if Input.is_action_pressed("right"):
		command_dir += Vector2(1,0)
	if Input.is_action_pressed("left"):
		command_dir -= Vector2(1,0)
	movement_dir = command_dir.normalized()
	if state == states.ACTIVE:
		position += movement_speed*movement_dir*delta
	elif state == states.FINISHED:
		if Time.get_ticks_msec() > finish_time+3000:
			if Globals.level_to_complete == CurrentLevelNumber:
				Globals.level_to_complete += 1
				if Globals.level_to_complete == len(Globals.levels):
					Globals.level_to_complete = 0
			if CurrentLevelNumber < len(Globals.levels)-1:
				Globals.change_scene(Globals.levels[CurrentLevelNumber+1])
			else:
				Globals.change_scene("res://Main Menu.tscn")


func _on_player_collision_area_entered(area: Area2D) -> void:
	if area == CollisionArea:
		global_position = SnapTarget.global_position
		state = states.FINISHED
		finish_time = Time.get_ticks_msec()

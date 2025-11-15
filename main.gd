extends Node2D

@export var input_action: StringName = "main"
@export var data: GameData
@onready var text = $Text
@onready var story = $StoryText
@onready var sound = $MainSound

var time_since_last_release: float = 0.0
const TIME_TOLERANCE: float = 0.30 # % tolerance of deviation from gap
var recording: bool = false

# player_actions stores gaps between space presses in seconds
var player_actions: Array[float] = []

# if map is -1, equivalent to allowing one space press to next step in storyline
func translate_input(actions: Array[float], map: Array, tol: float) -> bool:
	if is_equal_approx(map[0], -1):
		return true
	if actions.size() == 0 || actions.size() != map.size():
		return false
	for i in range(map.size()):
		var cur_gap = actions[i]
		var map_gap = map[i]
		
		if not is_equal_approx(map_gap, -1) and abs(cur_gap - map_gap) / map_gap > tol:
			return false
		
	return true

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var just_started: bool = false
	if Input.is_action_just_pressed(input_action):
		sound.play()
		just_started = not recording
		recording = true
	if recording:
		time_since_last_release += delta
		
		if Input.is_action_just_pressed(input_action) and not just_started:
			player_actions.append(time_since_last_release)
			print("player actions: ", player_actions)
			time_since_last_release = 0.0
		
		var success = translate_input(player_actions, data.get_beat_map(), TIME_TOLERANCE)
		
		if player_actions.size() == data.get_beat_map().size() or success:
			print(player_actions, "resulted in a grand success" if success else "failed!!")
			reset(success)
		
		text.text = str(time_since_last_release)
		
func reset(success: bool) -> void:
	story.text = data.get_story(success)
	player_actions = []
	recording = false
	time_since_last_release = 0.0
	if success:
		data.next()

extends Resource
class_name GameData

@export var beats: Array[String]
@export var story_lines: Array[String]

var beat_maps: Array[Array]
var current: int = 0

"""
quarter notes every 0.4615 sec

eighth notes every .23075 sec

half notes every 0.923 sec

dotted quarter note every 0.69225
"""

var beat: Array[float] = [0.4615, 0.23075, 0.923, 0.69225, -1]

func gen_bms() -> void:
	for i in range(beats.size()):
		beat_maps.append([])
		for s in beats[i]:
			var selection: int
			match s:
				"q":
					selection = 0
				"e":
					selection = 1
				"h":
					selection = 2
				"d":
					selection = 3
				_:
					selection = 4
			beat_maps[i].append(beat[selection])
	# debug
	print("Finished beatmap generation")
	for a in beat_maps:
		print(a)

func get_story(success: bool) -> String:
	if success:
		return story_lines[current]
	else:
		return "failure"
	
func get_beat_map() -> Array:
	return beat_maps[current]
	
func next() -> bool:
	if current < beat_maps.size() - 1:
		current += 1
	return current < beat_maps.size() - 1

extends Resource
class_name GameData

@export var beat_maps: Array[Array]
@export var story_lines: Array[String]

var current: int = 0

"""
quarter notes every 0.4615 sec

eighth notes every .23075 sec

half notes every 0.923 sec

dotted quarter note every 0.69225
"""

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

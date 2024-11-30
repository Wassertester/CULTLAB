extends Resource
class_name save_game
const SAVE_PATH = "user://save.tres"
const START_POINT = Vector2(-800, 2)
@export var respawn_cords: Vector2 

func save(cords):
	respawn_cords = cords
	ResourceSaver.save(self, SAVE_PATH)

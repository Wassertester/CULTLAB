extends Resource
class_name save_game
const SAVE_PATH = "user://save.tres"
const START_POINT = Vector2(-800, 2)
@export var respawn_cords: Vector2 
@export var easy_mode: bool

func save():
	ResourceSaver.save(self, SAVE_PATH)

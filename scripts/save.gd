extends Resource
class_name save_game
const SAVE_PATH = "user://save.tres"
#const START_POINT = Vector2(-800, 2)
const START_POINT = Vector2(-11750, -30)#-2600, 1360
@export var respawn_cords: Vector2 
@export var easy_mode: bool
@export var restart: bool

func save():
	ResourceSaver.save(self, SAVE_PATH)

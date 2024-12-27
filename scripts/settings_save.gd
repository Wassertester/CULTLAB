extends Resource
class_name settings_save
const SAVE_PATH = "user://settings.tres"
@export var settings: Dictionary

func save():
	ResourceSaver.save(self, SAVE_PATH)

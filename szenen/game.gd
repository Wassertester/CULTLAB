extends Node2D
@onready var resume: Button = $Settings/MarginContainer/VBoxContainer/resume


signal camera
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		main_menu()
	

	
func main_menu():
	Engine.time_scale = 0
	camera.emit("menu")

	

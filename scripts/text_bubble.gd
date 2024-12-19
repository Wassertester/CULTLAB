extends Node2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var timer: Timer = $Timer
@onready var visible_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var notifier_unten: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D2
@onready var notifier_oben: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D3
@export var flip: bool
@export var proximity_trigger: bool
@export_multiline var contens: String
var started: bool 
var displayed_text: String
var counter: int = 0
var message: int = 0
var ready_ = 0
var end_of_message: bool = false

func _ready() -> void:
	sprite.flip_h = flip
	label.text = ""
	label.visible = false
	sprite.visible = false

func _process(delta: float) -> void:
	if started and Input.is_action_just_pressed("interact") and visible_notifier.is_on_screen():
		next_message()
	if proximity_trigger:
		if notifier_unten.is_on_screen() and notifier_oben.is_on_screen():
			start()

func _on_timer_timeout() -> void:
	if counter < contens.length():
		if contens[counter] == "§":
			end_of_message = true
		if not end_of_message:
			label.text =  label.text + contens[counter]
			counter += 1
	
func next_message():
	label.text = ""
	if counter == 0:
		timer.start()
		end_of_message = false
		if contens[counter] == "§":
			counter += 1
	else:
		if counter < contens.length() -1:
			while contens[counter] != "§" and counter < contens.length() -1:
				counter += 1
			counter += 1
			end_of_message = false
		else:
			timer.stop()
			counter -= 1
			label.visible = false
			sprite.visible = false

func start():
	if not started:
		label.visible = true
		sprite.visible = true
		started = true
		timer.start()
